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
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = KodiListSort.getSortSetting(sortID: SceneState.shared.mainSelection.item.title)
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
                PartsView.StatusMessage(router: .tvshows, status: state)
            }
        }
        .animation(.default, value: state)
        .task(id: kodi.library.tvshows) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.tvshows.isEmpty {
                state = .empty
            } else {
                getTVShows()
                state = .ready
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
