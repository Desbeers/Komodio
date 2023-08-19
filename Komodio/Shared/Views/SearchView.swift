//
//  SearchView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Search View

/// SwiftUI `View` for search results
struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The Music Videos to show
    @State private var musicVideos: [Video.Details.MusicVideo] = []
    /// The TV shows to show
    @State private var tvshows: [Video.Details.TVShow] = []
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "search", method: .media, order: .ascending)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// Bool if we have results
    var results: Bool {
        return !movies.isEmpty || !musicVideos.isEmpty || !tvshows.isEmpty
    }

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            content
        }
        .animation(.default, value: state)
        .task(id: scene.query) {
            scene.detailSelection = .search
            search()
        }
        .onChange(of: kodi.library) { _ in
            search()
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.search.item.title,
                    subtitle: Router.search.item.description
                )
            },
            content: {
                switch state {
                case .ready:
                    CollectionView(
                        collection: $collection,
                        sorting: $sorting,
                        collectionStyle: scene.collectionStyle
                    )
                default:
                    PartsView.StatusMessage(router: scene.mainSelection, status: state)
                        .backport.focusable()
                }
            },
            buttons: {
                Buttons.CollectionStyle()
            }
        )
#if os(tvOS)
        .searchable(text: $scene.query)
#endif
    }

    /// Perform the search
    @MainActor private func search() {
        if scene.query.isEmpty {
            collection = []
        } else {

            var items: [any KodiItem] = []

            items += kodi.library.movies.search(scene.query)
            items += kodi.library.musicVideos.search(scene.query)
            items += kodi.library.tvshows.search(scene.query)

            if items.isEmpty {
                state = .empty
            } else {

                /// Map the items in collections
                collection = items.anykodiItem()
                state = .ready
            }
        }
    }
}
