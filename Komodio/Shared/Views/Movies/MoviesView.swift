//
//  MoviesView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movies View

/// SwiftUI `View` for all Movies in the library (shared)
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
    @State var sorting = KodiListSort.getSortSetting(sortID: SceneState.shared.mainSelection.item.title)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: scene.mainSelection, status: state)
                    .backport.focusable()
            }
        }
        .animation(.default, value: items.map { $0.id })
        .task(id: filter) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                getMovies()
            }
        }
        .onChange(of: sorting) { [sorting] newValue in
            if sorting.method == newValue.method {
                items.sort(sortItem: newValue)
            } else {
                getMovies()
            }
        }
        .onChange(of: kodi.library.movies) { _ in
            getMovies()
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {

#if os(macOS)
        ScrollView {
            KodiListSort.PickerView(sorting: $sorting, media: .movie)
                .padding()
            LazyVStack {
                ForEach(items, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        Button(
                            action: {
                                scene.detailSelection = .movie(movie: movie)
                            },
                            label: {
                                MoviesView.ListItem(movie: movie, sorting: sorting)
                            }
                        )
                        .buttonStyle(.kodiItemButton(kodiItem: movie))
                    case let movieSet as Video.Details.MovieSet:
                        NavigationLink(value: Router.movieSet(movieSet: movieSet), label: {
                            MovieSetView.ListItem(movieSet: movieSet)
                        })
                        .buttonStyle(.kodiItemButton(kodiItem: movieSet))
                    default:
                        EmptyView()
                    }
                    Divider()
                }
            }
            .padding()
        }
#endif

#if os(tvOS) || os(iOS)
        ContentView.Wrapper(
            header: {
                ZStack {
                    PartsView
                        .DetailHeader(
                            title: scene.mainSelection.item.title,
                            subtitle: scene.mainSelection.item.description
                        )
                    if KomodioApp.platform == .tvOS {
                        Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                            .labelStyle(.headerLabel)
                            .padding(.leading, 50)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            },
            content: {
                LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                    ForEach(items, id: \.id) { video in
                        switch video {
                        case let movie as Video.Details.Movie:
                            NavigationLink(value: Router.movie(movie: movie), label: {
                                MoviesView.ListItem(movie: movie, sorting: sorting)
                            })
                            .padding(.bottom, KomodioApp.posterSize.height / 9)
                        case let movieSet as Video.Details.MovieSet:
                            NavigationLink(value: Router.movieSet(movieSet: movieSet), label: {
                                MovieSetView.ListItem(movieSet: movieSet)
                            })
                            .padding(.bottom, KomodioApp.posterSize.height / 9)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        )
        .backport.cardButton()
        .toolbar {
            if KomodioApp.platform == .iPadOS {
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                    .labelStyle(.titleAndIcon)
            }
        }

#endif
    }

    // MARK: Private functions

    /// Get all movies from the library
    private func getMovies() {
        Task { @MainActor in
            var items: [Video.Details.Movie] = []
            switch filter {
            case .unwatched:
                items = kodi.library.movies
                    .filter { $0.playcount == 0 }
            case .playlist(let file):
                let playlist = await Files.getDirectory(directory: file.file, media: .video).compactMap(\.id)
                items = kodi.library.movies
                    .filter { playlist.contains($0.movieID) }
            default:
                items = kodi.library.movies
            }
            scene.movieItems = items
                .filter { $0.setID != 0 }.map(\.movieID)
            self.items = sorting.method == .title ? items.swapMoviesForSet() : items
            self.items.sort(sortItem: sorting)
            /// Set the loading state
            state = self.items.isEmpty ? .empty : .ready
        }
    }
}
