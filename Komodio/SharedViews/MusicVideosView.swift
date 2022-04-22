//
//  MusicVideosView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI


/// The base View for music videos
struct MusicVideosView {
    /// Just a placeholder; the base for Music Videos is the ArtistView
}

extension MusicVideosView {
    
    /// A View with all Music Video items for a selected artist
    struct Artist: View {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The artist who's videos to show
        private let artist: MediaItem
        /// The items to show
        private let items: [MediaItem]
        /// Init the View
        init(artist: MediaItem) {
            self.artist = artist
            self.items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: artist.artists))
        }
        /// The View
        var body: some View {
            ZStack(alignment: .topLeading)  {
                ItemsView.List() {
                    ForEach(items) { item in
                        ItemsView.Item(item: item.binding())
                    }
                    .macOS { $0.padding(.horizontal, 80) }
                    .tvOS { $0.padding(.horizontal, 80) }
                }
                /// Make room for the details
                .macOS { $0.padding(.leading, 330) }
                .tvOS { $0.padding(.leading, 550) }
                .iOS { $0.padding(.leading, 330) }
                /// View the details
                ItemsView.Details(item: artist)
            }
            .task {
                if router.selectedMediaItem == nil {
                    router.setSelectedMediaItem(item: items.first)
                }
            }
        }
    }

    /// A View for one Music Video Item
    /// - Note: If the video belongs to an album it will be shown as an 'album link'
    struct Item: View {
        @Binding var musicvideo: MediaItem
        var body: some View {
            if musicvideo.album.isEmpty {
                RouterLink(item: .details(item: musicvideo)) {
                    ItemsView.Basic(item: $musicvideo)
                }
                .buttonStyle(ButtonStyles.MediaItem(item: musicvideo))
            } else {
                AlbumItem(album: musicvideo)
            }
        }
    }
    
    /// A View for an album of music videos
    struct Album: View {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The album item for this View
        private var album: MediaItem
        /// The music videos to show
        private var musicVideos: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 340))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 240))]
#endif
        init(album: MediaItem) {
            self.album = album
            musicVideos = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: album.artists, album: album))
        }
        /// The View
        var body: some View {
            ItemsView.List() {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(musicVideos) { musicVideo in
                        RouterLink(item: .details(item: musicVideo)) {
                            VStack {
                                ArtView.Thumbnail(item: musicVideo)
                                    .macOS { $0.frame(width: 240, height: 135) }
                                    .tvOS { $0.frame(width: 320, height: 180) }
                                Text(musicVideo.title)
                            }
                                .watchStatus(of: musicVideo.binding())
                        }
                        .buttonStyle(ButtonStyles.MediaItem(item: musicVideo))
                    }
                }
                .macOS { $0.padding(.horizontal, 80) }
                .tvOS { $0.padding(.horizontal, 160) }
            }
            .task {
                if router.selectedMediaItem == nil {
                    router.setSelectedMediaItem(item: musicVideos.first)
                }
            }
        }
    }
    
    /// A View for an album item that contains music videos
    struct AlbumItem: View {
        /// The album to show
        let album: MediaItem
        /// The View
        var body: some View {
            RouterLink(item: .musicVideosAlbum(album: album)) {
                HStack {
                    ArtView.Poster(item: album)
                    VStack(alignment: .leading) {
                        Text(album.album)
                            .font(.headline)
                        Text(album.artists.joined(separator: " & "))
                            .font(.caption.italic())
                        Divider()
                        Text("Album with Music Videos")
                    }
                }
            }
            .buttonStyle(ButtonStyles.MediaItem(item: album))
        }
    }
}
