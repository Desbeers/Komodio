//
//  FavouritesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 05/03/2023.
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Favorites View

/// SwiftUI `View` for Favorites (shared)
struct FavouritesView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items in this view
    @State private var items: [AnyKodiItem] = []
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "favorites", method: .title, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .favourites, status: state)
            }
        }
        .animation(.default, value: state)
        .task {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.favourites.isEmpty {
                state = .empty
            } else {
                getFavorites()
                state = .ready
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
