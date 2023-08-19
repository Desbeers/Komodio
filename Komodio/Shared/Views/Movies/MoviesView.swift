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
    /// The collection in this view (movies + movie sets)
    @State private var collection: [AnyKodiItem] = []
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
        .animation(.default, value: state)
        .task(id: filter) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                getMovies()
            }
        }
        .onChange(of: sorting) { [sorting] newSorting in
            if sorting.method == .title || newSorting.method == .title {
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
        ContentView.Wrapper(
            header: {
                PartsView
                    .DetailHeader(
                        title: scene.detailSelection.item.title,
                        subtitle: scene.detailSelection.item.description
                    )
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
            state = items.isEmpty ? .empty : .ready
            /// Map the items in collections
            collection = items.anykodiItem()
        }
    }
}
