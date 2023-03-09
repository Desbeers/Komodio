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
    /// The sorting
    @State var sorting = SceneState.getListSortSettings(sortID: SceneState.shared.contentSelection.label.title)
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
        .animation(.default, value: items.map(\.id))
        .task {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                getItems()
                state = .ready
            }
        }
        .onChange(of: kodi.library.movies) { _ in
            getItems()
            setItemDetails()
        }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        ZStack {
            List(selection: $selectedItem) {
                Pickers.ListSortPicker(sorting: $sorting, media: .movie)
                ForEach(items, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        MovieView.Item(movie: movie, sorting: sorting)
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
        .task(id: selectedItem) {
            setItemDetails()
        }
        .onChange(of: sorting) { [sorting] newValue in
            if sorting.method == newValue.method {
                items.sort(sortItem: newValue)
            } else {
                getItems()
            }
        }
#endif

#if os(tvOS)
        ScrollView {
            ZStack {
                PartsView.DetailHeader(title: getNavigationSubtitle())
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                    .labelStyle(.sortLabel)
                    .padding(.trailing, 40)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            .focusSection()
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(items, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        NavigationLink(value: movie, label: {
                            MovieView.Item(movie: movie, sorting: sorting)
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
#endif

    }

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        logger("Get Items")
        Task { @MainActor in
            var items: [Video.Details.Movie] = []
            switch filter {
            case .unwatched:
                items = kodi.library.movies
                    .filter({$0.playcount == 0})
            case .playlist(let file):
                let playlist = await Files.getDirectory(directory: file.file, media: .video).compactMap(\.id)
                items = kodi.library.movies.filter({playlist.contains($0.movieID)})
            default:
                items = kodi.library.movies
            }
            self.items = (sorting.method == .title ? swapMoviesForSet(movies: items) : items)
                .sorted(sortItem: sorting)
        }
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem {
            switch selectedItem.media {
            case .movie:
                if let movie = kodi.library.movies.first(where: {$0.id == selectedItem.id}) {
                    scene.details = .movie(movie: movie)
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
                scene.details = .unwatchedMovies
            case .playlist(let file):
                scene.details = .moviesPlaylist(file: file)
            default:
                scene.details = .movies
            }
            scene.navigationSubtitle = getNavigationSubtitle()
        }
    }

    /// Swap movies for a set item
    ///
    /// Movies that are part of a set will be removed and replaced with the set when enabled in the Kodi host
    private func swapMoviesForSet(movies: [Video.Details.Movie]) -> [any KodiItem] {
        if KodiConnector.shared.getKodiSetting(id: .videolibraryGroupMovieSets).bool {
            let movieSetIDs = Set(movies.map(\.setID))
            let movieSets = kodi.library.movieSets.filter({movieSetIDs.contains($0.setID)})
            scene.movieItems = movies.filter({$0.setID != 0}).map(\.movieID)
            return (movies.filter({$0.setID == 0}) + movieSets)
        }
        return movies
    }

    /// Get the navigation subtitle
    private func getNavigationSubtitle() -> String {
        switch filter {
        case .unwatched:
            return Router.unwatchedMovies.label.title
        case .playlist(let file):
            return  file.title
        default:
            return Router.movies.label.title
        }
    }
}
