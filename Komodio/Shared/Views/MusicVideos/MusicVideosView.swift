//
//  MusicVideosView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Music Videos View

/// SwiftUI `View` for all Music Videos of an Artist; grouped by optional Album (shared)
struct MusicVideosView: View {
    /// The selected artist
    let artist: Audio.Details.Artist
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The collection to show in this view. Can be a single Music Video or an album with Music Videos
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "musicVideos", method: .year, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .task(id: artist) {
                getItems()
            }
            .onChange(of: kodi.library.musicVideos) {
                getItems()
            }
    }

    // MARK: Content of the View

    /// The content of the `view`
    @ViewBuilder var content: some View {
#if os(macOS)
        ContentView.Wrapper(
            header: {},
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
#endif

#if os(tvOS) || os(iOS) || os(visionOS)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(title: artist.title)
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    CollectionView(
                        collection: $collection,
                        sorting: $sorting,
                        collectionStyle: .asPlain,
                        showIndex: false
                    )
                    .frame(width: StaticSetting.contentWidth, alignment: .leading)
                    .backport.focusSection()
                    DetailView()
                        .padding(.leading, StaticSetting.detailPadding)
                }
            },
            buttons: {}
        )
#endif
    }

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        let allMusicVideosFromArtist = kodi.library.musicVideos
            .filter { $0.artist.contains(artist.artist) }
        let items = allMusicVideosFromArtist
            .swapMusicVideosForAlbums(artist: artist)
        /// Map the items in collections
        collection = items.anykodiItem()
        if
            let album = scene.detailSelection.item.kodiItem,
            album.media == .musicVideoAlbum,
            let update = items.first(where: { $0.id == album.id }) as? Video.Details.MusicVideoAlbum {
            /// Update the selected Music Video Album
            scene.detailSelection = .musicVideoAlbum(musicVideoAlbum: update)
        }
    }
}
