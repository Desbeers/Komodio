//
//  TVShowsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: TV shows View

/// SwiftUI `View` for all TV shows (shared)
struct TVShowsView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State var sorting = SwiftlyKodiAPI.List.Sort()
    /// The loading state of the View
    @State private var status: ViewStatus = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .ready:
                content
            default:
                status.message(router: .tvshows)
            }
        }
        .animation(.default, value: status)
        .task(id: kodi.library.tvshows) {
            if kodi.status != .loadedLibrary {
                status = .offline
            } else if kodi.library.tvshows.isEmpty {
                status = .empty
            } else {
                sorting = KodiListSort.getSortSetting(sortID: scene.mainSelection.item.title)
                getTVShows()
                status = .ready
            }
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.tvshows.item.title,
                    subtitle: Router.tvshows.item.description
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
                Buttons.CollectionSort(sorting: $sorting, media: .tvshow)
            }
        )
    }

    // MARK: Private functions

    /// Get all movies from the library
    private func getTVShows() {
        collection = kodi.library.tvshows.anykodiItem()
    }
}
