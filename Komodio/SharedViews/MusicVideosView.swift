//
//  MusicVideosView().swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi filter for this View
    let filter: KodiFilter
    /// The Music Video items to show in this view
    @State var musicvideos: [KodiItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(musicvideos) { musicvideo in
                let artist = kodi.getArtistInfo(artist: musicvideo.artist)
                RouterLink(item: .musicVideosItems(artist: artist)) {
                    Artist(artist: artist)
                }
                .buttonStyle(ButtonStyles.KodiItem(item: musicvideo))
            }
        }
        .task {
            print("MusicVideos task!")
            let filter = KodiFilter(media: .musicvideo)
            musicvideos = kodi.library.filter(filter)
            //router.fanart = ""
        }
        .iOS { $0.navigationTitle("Music Videos") }
    }
}

extension MusicVideosView {
    
    /// A View an artist from the Music Video items
    struct Artist: View {
        /// The Artist item to show in this view
        let artist: KodiItem
        /// The View
        var body: some View {
            HStack {
                ArtView.PosterList(poster: artist.poster)
                VStack(alignment: .leading) {
                    Text(artist.artist.joined(separator: " & "))
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
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        
        /// The Router model
        @EnvironmentObject var router: Router
        
        /// The Artist item
        let artist: KodiItem
        /// The Music Video items to show in this view
        @State var musicvideos: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List() {
#if os(tvOS)
                PartsView.TitleHeader()
#endif
                ForEach(musicvideos) { musicvideo in
                    ItemsView.Item(item: musicvideo.binding())
                }
            }
            .task {
                print("MusicVideos.Items task!")
                let filter = KodiFilter(media: .musicvideo, artist: artist.artist)
                musicvideos = kodi.library.filter(filter)
                //router.fanart = artist.fanart
                
            }
            .iOS { $0.navigationTitle(artist.artist.joined(separator: " & ")) }
        }
    }
    
    struct Item: View {
        //let artist: KodiItem
        @Binding var musicvideo: KodiItem
        var body: some View {
            
            RouterLink(item: .details(item: musicvideo)) {
                ItemsView.Basic(item: $musicvideo)
            }
            .buttonStyle(ButtonStyles.KodiItem(item: musicvideo))

            .buttonStyle(ButtonStyles.KodiItem(item: musicvideo))
            .contextMenu {
                Button(action: {
                    musicvideo.toggleWatchedState()
                }, label: {
                    Text(musicvideo.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
    
}
