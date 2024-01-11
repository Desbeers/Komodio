//
//  ArtistsView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Artists View

/// SwiftUI `View` for all Artists from Music Videos (shared)
struct ArtistsView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The artists in this view
    @State private var artists: [Audio.Details.Artist] = []
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The loading state of the View
    @State private var status: ViewStatus = .loading
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "artists", method: .title, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .ready:
                content
            default:
                status.message(router: .musicVideos)
            }
        }
        .animation(.default, value: status)
        .task(id: kodi.library.musicVideos) {
            if kodi.status != .loadedLibrary {
                status = .offline
            } else if kodi.library.musicVideos.isEmpty {
                status = .empty
            } else {
                getItems()
                status = .ready
            }
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.musicVideos.item.title,
                    subtitle: Router.musicVideos.item.description
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
            }
        )
    }

    // MARK: Private functions

    /// Get all artists from the library
    private func getItems() {
        collection = VideoLibrary.getMusicVideoArtists().anykodiItem()
    }
}
