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
    /// The Music Video items to show in this view
    @State var musicvideos: [MediaItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(kodi.media.filter(KodiFilter(media: .musicvideo))) { musicvideo in
                let artist = kodi.getArtistInfo(artist: musicvideo.artists)
                RouterLink(item: .musicVideosItems(artist: artist)) {
                    Artist(artist: artist)
                }
                .buttonStyle(ButtonStyles.MediaItem(item: musicvideo))
            }
        }
        .task {
            print("MusicVideos task!")
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
                ForEach(kodi.media.filter(KodiFilter(media: .musicvideo, artist: artist.artists))) { musicvideo in
                    ItemsView.Item(item: musicvideo.binding())
                }
            }
            .task {
                print("MusicVideos.Items task!")
            }
        }
    }
    
    struct Item: View {
        @Binding var musicvideo: MediaItem
        var body: some View {
            RouterLink(item: .details(item: musicvideo)) {
                ItemsView.Basic(item: $musicvideo)
            }
            .buttonStyle(ButtonStyles.MediaItem(item: musicvideo))
        }
    }
}
