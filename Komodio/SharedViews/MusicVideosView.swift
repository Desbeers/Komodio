//
//  MusicVideosView().swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(kodi.media.filter(MediaFilter(media: .musicVideoArtist))) { artist in
                RouterLink(item: .musicVideosItems(artist: artist)) {
                    Artist(artist: artist)
                }
                .buttonStyle(ButtonStyles.MediaItem(item: artist))
            }
        }
        .task {
            logger("MusicVideos task!")
        }
    }
}

extension MusicVideosView {
    
    /// A View an artist from the Music Video items
    struct Artist: View {
        /// The Artist item to show in this view
        let artist: MediaItem
        /// The View
        var body: some View {
            HStack {
                ArtView.PosterList(poster: artist.poster)
                VStack(alignment: .leading) {
                    Text(artist.title)
                        .font(.headline)
                    Divider()
                    Text(artist.description)
                        .lineLimit(2)
                }
            }
        }
    }
    
    /// A View with all Music Video items for a selected artist
    struct Items: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Artist item
        let artist: MediaItem
        /// The View
        var body: some View {
            ItemsView.List() {
                ForEach(kodi
                            .media.filter(MediaFilter(media: .musicvideo, artist: artist.artists))
                ) { musicvideo in
                    ItemsView.Item(item: musicvideo.binding())
                }
            }
            .task {
                logger("MusicVideos.Items task!")
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
    
    struct Album: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The album item for this View
        let album: MediaItem
        /// The View
        var body: some View {
            ItemsView.List() {
                ForEach(kodi.media.filter(MediaFilter(media: .musicvideo,
                                                     artist: album.artists,
                                                     album: album.album)
                                         )
                ) { movie in
                    RouterLink(item: .details(item: movie)) {
                        ItemsView.Basic(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.MediaItem(item: movie))
                }
            }
            .task {
                logger("MusicVideosView.Album task!")
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
                    ArtView.PosterList(poster: album.poster)
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
