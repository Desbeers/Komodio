//
//  FavouritesView.swift
//  Komodio
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Favorites View

/// SwiftUI `View` for Favorites (shared)
struct FavouritesView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The items in this view
    @State private var items: [AnyKodiItem] = []
    /// The loading state of the View
    @State private var status: ViewStatus = .loading
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "favorites", method: .media, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .ready:
                content
            default:
                status.message(router: .favourites)
            }
        }
        .animation(.default, value: status)
        .task {
            if kodi.status != .loadedLibrary {
                status = .offline
            } else if kodi.favourites.isEmpty {
                status = .empty
            } else {
                sorting = KodiListSort.getSortSetting(sortID: "favorites")
                getFavorites()
                status = .ready
            }
        }
        .task(id: kodi.favourites) {
            getFavorites()
        }
    }
    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.favourites.item.title,
                    subtitle: Router.favourites.item.description
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
                Buttons.CollectionSort(sorting: $sorting, media: .favorite)
            }
        )
    }

    // MARK: Private functions

    /// Get all movies from the library
    private func getFavorites() {
        collection = kodi.favourites
    }
}
