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
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items to show in this view. Can be a single Music Video or an album with Music Videos
    @State private var items: [any KodiItem] = []

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .task(id: artist) {
                getItems()
            }
            .onChange(of: kodi.library.musicVideos) { _ in
                getItems()
            }
    }

    // MARK: Content of the View

    /// The content of the `view`
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.id) { video in
                    button(video: video)
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
                            ForEach(items, id: \.id) { video in
                                button(video: video)
                                    .padding(.bottom, KomodioApp.posterSize.height / 20)
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

    // MARK: Navigation Button

    /// The Navigation `Button`
    func button(video: any KodiItem) -> some View {
        Button(
            action: {
                switch video {
                case let musicVideo as Video.Details.MusicVideo:
                    scene.details = .musicVideo(musicVideo: musicVideo)
                case let musicVideoAlbum as Video.Details.MusicVideoAlbum:
                    scene.details = .musicVideoAlbum(musicVideoAlbum: musicVideoAlbum)
                default:
                    break
                }
            },
            label: {
                MusicVideosView.ListItem(item: video)
            }
        )
        .buttonStyle(.kodiItemButton(kodiItem: video))
    }

    // MARK: Private functions

    /// Get all items from the library
    private func getItems() {
        let allMusicVideosFromArtist = kodi.library.musicVideos
            .filter { $0.artist.contains(artist.artist) }
        items = allMusicVideosFromArtist
            .swapMusicVideosForAlbums()
            .sorted(sortItem: .init(id: "MusicVideoAlbum", method: .year, order: .ascending))
        if
            let album = scene.details.item.kodiItem,
            album.media == .musicVideoAlbum,
            let update = items.first(where: { $0.id == album.id }) as? Video.Details.MusicVideoAlbum {
            /// Update the selected Music Video Album
            scene.details = .musicVideoAlbum(musicVideoAlbum: update)
        }
    }
}
