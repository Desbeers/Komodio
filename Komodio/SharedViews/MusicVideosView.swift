//
//  MusicVideosView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The artists to show
    private var artists: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 154))]
#endif
    init() {
        artists = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideoArtist))
    }
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(artists) { artist in
                        RouterLink(item: .musicVideosItems(artist: artist)) {
                            VStack {
                                ArtView.Poster(item: artist)
                                Text(artist.title)
                            }
                                    .macOS { $0.frame(width: 150) }
                                    .tvOS { $0.frame(width: 300) }
                                    .iOS { $0.frame(height: 200) }
                        }
                        .buttonStyle(ButtonStyles.MediaItem(item: artist))
                    }
                }
                .padding(.horizontal, 20)
            }
            /// Make room for the details
            .macOS { $0.padding(.leading, 330) }
            .tvOS { $0.padding(.leading, 550) }
            if router.selectedMediaItem != nil {
                ItemsView.Details(item: router.selectedMediaItem!)
            }
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: artists.first)
            }
        }
    }
}

//struct AAAMusicVideosView: View {
//    /// The KodiConnector model
//    @EnvironmentObject var kodi: KodiConnector
//    /// The View
//    var body: some View {
//        ItemsView.List() {
//            ForEach(kodi.media.filter(MediaFilter(media: .musicVideoArtist))) { artist in
//                RouterLink(item: .musicVideosItems(artist: artist)) {
//                    Artist(artist: artist)
//                }
//                .buttonStyle(ButtonStyles.MediaItem(item: artist))
//            }
//        }
//    }
//}

extension MusicVideosView {
    
//    /// A View for an artist in the Music Video items
//    struct Artist: View {
//        /// The Artist item to show in this view
//        let artist: MediaItem
//        /// The View
//        var body: some View {
//            HStack {
//                ArtView.Poster(item: artist)
//                VStack(alignment: .leading) {
//                    Text(artist.title)
//                        .font(.headline)
//                    Text(artist.subtitle)
//                        .font(.caption.italic())
//                    Divider()
//                    Text(artist.description)
//                        .lineLimit(2)
//                }
//            }
//        }
//    }
    
    /// A View with all Music Video items for a selected artist
    struct Items: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Artist item
        let artist: MediaItem
        /// The View
        var body: some View {
            ItemsView.List() {
                ForEach(kodi.media.filter(MediaFilter(media: .musicVideo, artist: artist.artists))) { musicvideo in
                    ItemsView.Item(item: musicvideo.binding())
                }
                .macOS { $0.padding(.horizontal, 80) }
                .tvOS { $0.padding(.horizontal, 160) }
            }
        }
    }

    /// A View for one Music Video Item
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
    
//    /// View all music videos from an album
//    struct Album: View {
//        /// The KodiConnector model
//        @EnvironmentObject var kodi: KodiConnector
//        /// The album item for this View
//        let album: MediaItem
//        /// The View
//        var body: some View {
//            ItemsView.List() {
//                ForEach(kodi.media.filter(MediaFilter(media: .musicVideo,
//                                                     artist: album.artists,
//                                                     album: album)
//                                         )
//                ) { movie in
//                    RouterLink(item: .details(item: movie)) {
//                        ItemsView.Basic(item: movie.binding())
//                    }
//                    .buttonStyle(ButtonStyles.MediaItem(item: movie))
//                }
//            }
//        }
//    }
    
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
    let grid = [GridItem(.adaptive(minimum: 400))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 154))]
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
                                Text(musicVideo.title)
                            }
                                .watchStatus(of: musicVideo.binding())
                                    .macOS { $0.frame(width: 150) }
                                    .tvOS { $0.frame(width: 400) }
                                    .iOS { $0.frame(height: 200) }
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
    
    /// A View for an album item
    struct AlbumItem: View {
        /// The Movie Set item from the library
        let album: MediaItem
        /// The View
        var body: some View {
            RouterLink(item: .musicVideosAlbum(album: album)) {
                HStack {
                    ArtView.Poster(item: album)
                        .macOS { $0.frame(width: 150) }
                        .tvOS { $0.frame(width: 200) }
                        .iOS { $0.frame(height: 200) }
                    VStack(alignment: .leading) {
                        Text(album.album)
                            .font(.headline)
                        Text(album.artists.joined(separator: " & "))
                            .font(.caption.italic())
                        Divider()
                        Text("Album with Music Videos")
                    }
                }
                //ItemsView.Basic(item: movieSet.binding())
            }
            .buttonStyle(ButtonStyles.MediaItem(item: album))
        }
    }
}
