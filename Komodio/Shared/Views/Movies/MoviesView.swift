//
//  MoviesView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Movies in the library (shared)
///
/// - Movies that are part of a set will be removed and replaced with the set when showing all movies and sorted by title
/// - When the library is filtered by 'unwatched', it will be sorted by 'date added'
struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items in this view (movies + movie sets)
    @State private var items: [any KodiItem] = []
    /// The optional filter
    var filter: Parts.Filter = .none
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// The optional selected movie set (macOS)
    @State private var selectedMovieSet = Video.Details.MovieSet(media: .none)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .movies, status: state)
            }
        }
        .animation(.default, value: selectedItem)
        .task(id: kodi.library.movies) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                getItems()
                setItemDetails()
                state = .ready
            }
        }
        .task(id: selectedItem) {
            setItemDetails()
        }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        ZStack {
            List(selection: $selectedItem) {
                ForEach(items, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        MovieView.Item(movie: movie)
                            .tag(MediaItem(id: movie.id, media: .movie))
                    case let movieSet as Video.Details.MovieSet:
                        MovieSetView.Item(movieSet: movieSet)
                            .tag(MediaItem(id: String(movieSet.setID), media: .movieSet))
                    default:
                        EmptyView()
                    }
                }
            }
            .scaleEffect(selectedItem?.media == .movieSet ? 0.6 : 1)
            .offset(x: selectedItem?.media == .movieSet ? -ContentView.columnWidth : 0, y: 0)
            MovieSetView(movieSet: selectedMovieSet)
                .offset(x: selectedItem?.media == .movieSet ? 0 : ContentView.columnWidth, y: 0)
                .opacity(selectedItem?.media == .movieSet ? 1 : 0)
        }
        .toolbar {
            /// The selection might not be a set
            if selectedItem?.media == .movieSet {
                /// Show a 'back' button
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        selectedMovieSet.media = .none
                        selectedItem = nil
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
#endif

#if os(tvOS)
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach($items, id: \.id) { $video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        NavigationLink(value: movie, label: {
                            MovieView.Item(movie: movie)
                        })
                        .padding(.bottom, 40)
                    case let movieSet as Video.Details.MovieSet:
                        NavigationLink(value: movieSet, label: {
                            MovieSetView.Item(movieSet: movieSet)
                        })
                        .padding(.bottom, 40)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .buttonStyle(.card)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .setSafeAreas()
#endif

    }

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        switch filter {
        case .unwatched:
            /// Movies are sorted by newest first
            items = kodi.library.movies
                .filter({$0.playcount == 0})
                .sorted(using: KeyPathComparator(\.dateAdded, order: .reverse))
        case .playlist(let file):
            Task { @MainActor in
                var playlist: [Video.Details.Movie] = []
                let items = await Files.getDirectory(directory: file.file, media: .video)
                for item in items {
                    if let movie = kodi.library.movies.first(where: {$0.file == item.file}) {
                        playlist.append(movie)
                    }
                }
                /// Movies that are part of a set will be removed and replaced with the set
                self.items = swapMoviesForSet(movies: playlist)
            }
        default:
            /// Movies that are part of a set will be removed and replaced with the set
            items = swapMoviesForSet(movies: kodi.library.movies)
        }
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem {
            switch selectedItem.media {
            case .movie:
                if let movie = kodi.library.movies.first(where: {$0.id == selectedItem.id}) {
                    scene.details = .movie(movie: movie)
                    /// Not a movie set
                    selectedMovieSet.setID = 0
                }
            case .movieSet:
                if let movieSet = kodi.library.movieSets.first(where: {$0.setID == Int(selectedItem.id)}) {
                    selectedMovieSet = movieSet
                }
            default:
                break
            }
        } else {
            switch filter {
            case .unwatched:
                scene.navigationSubtitle = "Unwatched Movies"
                scene.details = .unwatchedMovies
            case .playlist(let file):
                scene.navigationSubtitle = file.title
                scene.details = .moviesPlaylist(file: file)
            default:
                scene.navigationSubtitle = Router.movies.label.title
                scene.details = .movies
            }
        }
    }

    /// Swap movies for a set item
    ///
    /// Movies that are part of a set will be removed and replaced with the set
    private func swapMoviesForSet(movies: [Video.Details.Movie]) -> [any KodiItem] {
        let movieSetIDs = Set(movies.map(\.setID))
        let movieSets = kodi.library.movieSets.filter({movieSetIDs.contains($0.setID)})
        return (movies.filter({$0.setID == 0}) + movieSets).sorted(using: KeyPathComparator(\.sortByTitle))
    }
}
