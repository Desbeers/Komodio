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
    /// The opacity of the View
    @State private var opacity: Double = 0
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .playlists, status: state)
                    .focusable()
            }
        }
        .task(id: artist) {
            opacity = 1
            scene.selectedKodiItem = artist
            scene.navigationSubtitle = artist.artist
        }
        .task(id: kodi.library.musicVideos) {
            getItems()
            setItemDetails()
            state = .ready
        }
        .task(id: selectedItem) {
            setItemDetails()
        }
    }

    // MARK: Content of the MusicVideosView

#if os(macOS)
    /// The content of the view
    var content: some View {
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
                    .buttonStyle(.listButton(selected: selectedItem?.id == item.id))
                    Divider()
                }
            }
            .padding()
        }
        .offset(x: opacity == 0 ? ContentView.columnWidth : 0, y: 0)
        .opacity(opacity)
    }
#endif

#if os(tvOS)
    /// The content of the view
    var content: some View {
        ContentWrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(
                    title: artist.title
                )
            }, content: {
                HStack(spacing: 0) {
                    List {
                        ForEach(items) { item in
                            Button(action: {
                                selectedItem = item
                            }, label: {
                                MusicVideoView.Item(item: item)
                            })
                        }
                    }
                    .frame(width: KomodioApp.posterSize.width + 120)
                    .buttonStyle(.card)
                    DetailView()
                        .focusSection()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 80)
            })
    }
#endif

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
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
