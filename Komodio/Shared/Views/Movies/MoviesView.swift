//
//  MoviesView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movies View

/// SwiftUI View for all Movies in the library (shared)
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
    @State var sorting = KodiListSort.getSortSetting(sortID: SceneState.shared.sidebarSelection.label.title)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .movies, status: state)
                    .backport.focusable()
            }
        }
        .task(id: filter) {
            scene.navigationSubtitle = getNavigationSubtitle()
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
        }
    }

    // MARK: Content of the View

    /// The content of the View
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
                                scene.selectedKodiItem = movie
                                scene.details = .movie(movie: movie)
                            },
                            label: {
                                MovieView.Item(movie: movie, sorting: sorting)
                            }
                        )
                        .buttonStyle(.listButton(selected: scene.selectedKodiItem?.id == movie.id))
                    case let movieSet as Video.Details.MovieSet:
                        NavigationLink(value: movieSet, label: {
                            MovieSetView.Item(movieSet: movieSet)
                        })
                        .buttonStyle(.listButton(selected: false))
                    default:
                        EmptyView()
                    }
                    Divider()
                }
            }
            .padding()
        }
        .animation(.default, value: sorting)
        .onChange(of: sorting) { [sorting] newValue in
            if sorting.method == newValue.method {
                items.sort(sortItem: newValue)
            } else {
                getItems()
            }
        }
#endif

#if os(tvOS) || os(iOS)
        ContentWrapper(
            header: {
                ZStack {
                    PartsView.DetailHeader(title: getNavigationTitle(), subtitle: getNavigationSubtitle())
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
        )
        .backport.cardButton()
        .animation(.default, value: items.map { $0.id })
        .toolbar {
            if KomodioApp.platform == .iPadOS {
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                    .labelStyle(.titleAndIcon)
            }
        }
        .onChange(of: sorting) { [sorting] newValue in
            if sorting.method == newValue.method {
                items.sort(sortItem: newValue)
            } else {
                getItems()
            }
        }
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
        }
    }

    /// Get the navigation title
    private func getNavigationTitle() -> String {
        switch filter {
        case .unwatched:
            return Router.unwatchedMovies.label.title
        case .playlist(let file):
            return  file.title
        default:
            return Router.movies.label.title
        }
    }

    /// Get the navigation subtitle
    private func getNavigationSubtitle() -> String {
        switch filter {
        case .unwatched:
            return Router.unwatchedMovies.label.description
        case .playlist:
            return "Playlist"
        default:
            return Router.movies.label.description
        }
    }
}
