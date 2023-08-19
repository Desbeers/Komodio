//
//  ArtistsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Artists View

/// SwiftUI `View` for all Artists from Music Videos (shared)
struct ArtistsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The artists in this view
    @State var artists: [Audio.Details.Artist] = []
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "artists", method: .title, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .musicVideos, status: state)
            }
        }
        .task(id: kodi.library.musicVideos) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.musicVideos.isEmpty {
                state = .empty
            } else {
                getItems()
                state = .ready
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
