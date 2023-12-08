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
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The collection in this view (movies + movie sets)
    @State private var collection: [AnyKodiItem] = []
    /// The optional filter
    var filter: Parts.Filter = .none
    /// The sorting
    @State var sorting = SwiftlyKodiAPI.List.Sort()
    /// The loading status of the View
    @State private var status: ViewStatus = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .ready:
                content
            default:
                status.message(router: scene.mainSelection)
                    .backport.focusable()
            }
        }
        .animation(.default, value: status)
        .task(id: filter) {
            if kodi.status != .loadedLibrary {
                status = .offline
            } else if kodi.library.movies.isEmpty {
                status = .empty
            } else {
                sorting = KodiListSort.getSortSetting(sortID: scene.mainSelection.item.title)
                getMovies()
            }
        }
        .onChange(of: sorting) { oldSorting, newSorting in
            if oldSorting.method == .title || newSorting.method == .title {
                getMovies()
            }
        }
        .onChange(of: kodi.library.movies) {
            getMovies()
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {
        ContentView.Wrapper(
            header: {
                switch filter {
                case .playlist(let file):
                    PartsView
                        .DetailHeader(
                            title: file.title,
                            subtitle: "Movie playlist"
                        )
                default:
                    PartsView
                        .DetailHeader(
                            title: scene.mainSelection.item.title,
                            subtitle: scene.mainSelection.item.description
                        )
                }
            },
            content: {
                CollectionView(
                    collection: $collection,
                    sorting: $sorting,
                    collectionStyle: scene.collectionStyle
                )
            },
            buttons: {
                Buttons.CollectionStyle()
                Buttons.CollectionSort(sorting: $sorting, media: .movie)
            }
        )
    }

    // MARK: Private functions

    /// Get all movies from the library
    private func getMovies() {
        Task { @MainActor in
            var movies: [Video.Details.Movie] = []
            switch filter {
            case .unwatched:
                movies = kodi.library.movies
                    .filter { $0.playcount == 0 }
            case .playlist(let file):
                let playlist = await Files.getDirectory(directory: file.file, media: .video).compactMap(\.id)
                movies = kodi.library.movies
                    .filter { playlist.contains($0.movieID) }
            default:
                movies = kodi.library.movies
            }
            scene.movieItems = movies
                .filter { $0.setID != 0 }.map(\.movieID)
            var items = sorting.method == .title ? movies.swapMoviesForSet() : movies
            items.sort(sortItem: sorting)
            /// Set the loading state
            status = items.isEmpty ? .empty : .ready
            /// Map the items in collections
            collection = items.anykodiItem()
        }
    }
}
