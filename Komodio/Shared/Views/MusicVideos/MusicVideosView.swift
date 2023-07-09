//
//  MusicVideosView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Music Videos View

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
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .task(id: kodi.library.musicVideos) {
                getItems()
                setItemDetails()
                state = .ready
            }
            .task(id: selectedItem) {
                setItemDetails()
            }
    }

    // MARK: Content of the View

    /// The content of the `view`
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            LazyVStack {
                ForEach(items) { item in
                    Button(
                        action: {
                            selectedItem = item
                        },
                        label: {
                            MusicVideoView.Item(item: item)
                        }
                    )
                    .buttonStyle(.kodiItemButton(kodiItem: item.item))
                    Divider()
                }
            }
            .padding()
        }
#endif

#if os(tvOS) || os(iOS)
        ContentView.Wrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(title: artist.title)
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    ScrollView {
                        LazyVStack {
                            ForEach(items) { item in
                                Button(action: {
                                    selectedItem = item
                                }, label: {
                                    MusicVideoView.Item(item: item)
                                })
                            }
                        }
                        .padding(.vertical, KomodioApp.contentPadding)
                    }
                    .frame(width: KomodioApp.columnWidth, alignment: .leading)
                    .backport.focusSection()
                    DetailView()
                        .padding(.leading, KomodioApp.contentPadding)
                }
            }
        )
        .backport.cardButton()
#endif
    }

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        var result: [MediaItem] = []
        let allMusicVideosFromArtist = kodi.library.musicVideos
            .filter { $0.artist.contains(artist.artist) }
        for video in allMusicVideosFromArtist.uniqueAlbum() {
            var item = video
            var count: Int = 1
            if !video.album.isEmpty {
                let albumMusicVideos = allMusicVideosFromArtist
                    .filter { $0.album == video.album }
                count = albumMusicVideos.count
                /// Set the watched state for an album
                if count != 1, !albumMusicVideos.filter({ $0.playcount == 0 }).isEmpty {
                    item.playcount = 0
                    item.resume.position = 0
                }
            }
            result.append(
                MediaItem(
                    id: count == 1 ? video.title : video.album,
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
            scene.details = .musicVideoArtist(artist: artist)
        }
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem, let musicVideo = selectedItem.item as? Video.Details.MusicVideo {
            switch selectedItem.media {
            case .musicVideo:
                scene.details = .musicVideo(musicVideo: musicVideo)
            case.album:
                /// Get all Music Videos from the specific artist and album
                let musicVideos = kodi.library.musicVideos
                    .filter { $0.artist.contains(musicVideo.artist) && $0.album == musicVideo.album }
                scene.details = Router.musicVideoAlbum(musicVideos: musicVideos)
            default:
                break
            }
        }
    }
}
