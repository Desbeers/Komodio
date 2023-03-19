//
//  MusicVideosView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Music Videos of an Artist; grouped by optional Album (shared)
struct MusicVideosView: View {
    /// The selected artist
    let artist: Audio.Details.Artist
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The items to show in this view. Can be music video or album
    @State private var items: [MediaItem] = []
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// The body of the View
    var body: some View {
        content
            .task(id: artist) {
                getItems()
            }
            .task(id: kodi.library.musicVideos) {
                getItems()
                setItemDetails()
            }
            .task(id: selectedItem) {
                setItemDetails()
            }
    }

    // MARK: Content of the MusicVideosView

#if os(macOS)
    /// The content of the view
    var content: some View {
        List(selection: $selectedItem) {
            ForEach(items) { item in
                MusicVideoView.Item(item: item)
                    .tag(item)
            }
        }
    }
#endif

#if os(tvOS)
    /// The content of the view
    var content: some View {
        HStack {
            List {
                ForEach(items) { item in
                    Button(action: {
                        selectedItem = item
                    }, label: {
                        MusicVideoView.Item(item: item)
                    })
                }
            }
            .frame(width: KomodioApp.posterSize.width + 80)
            DetailView()
                .frame(maxWidth: .infinity)
                .focusSection()
        }
        .buttonStyle(.card)
    }
#endif

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        if artist.media == .artist {
            var result: [MediaItem] = []
            let allMusicVideosFromArtist = kodi.library.musicVideos
                .filter { $0.artist.contains(artist.artist) }
            for video in allMusicVideosFromArtist.uniqueAlbum() {
                let albumMusicVideos = allMusicVideosFromArtist
                    .filter { $0.album == video.album }
                let count = albumMusicVideos.count
                var item = video
                /// Set the watched state for an album
                if count != 1, !albumMusicVideos.filter({ $0.playcount == 0 }).isEmpty {
                    item.playcount = 0
                    item.resume.position = 0
                }
                result
                    .append(
                        MediaItem(
                            id: count == 1 ? video.id : video.album,
                            media: count == 1 ? .musicVideo : .album,
                            item: item
                        )
                    )
            }
            items = result
            /// Update the optional selected item
            if let selectedItem {
                self.selectedItem = items.first { $0.id == selectedItem.id }
            } else {
                scene.details = .artist(artist: artist)
            }
            scene.navigationSubtitle = artist.artist
        } else {
            /// Make sure we don't have an old selection
            selectedItem = nil
        }
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem, let musicVideo = selectedItem.item as? Video.Details.MusicVideo {
            switch selectedItem.media {
            case .musicVideo:
                scene.details = Router.musicVideo(musicVideo: musicVideo)
            case.album:
                /// Get all Music Videos from the specific artist and album
                let musicVideos = kodi.library.musicVideos
                    .filter { $0.artist.contains(musicVideo.artist) && $0.album == musicVideo.album }
                scene.details = Router.album(musicVideos: musicVideos)
            default:
                break
            }
        }
    }
}
