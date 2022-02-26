//
//  MusicVideosView().swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi filter for this View
    let filter: KodiFilter
    /// The Music Video items to show in this view
    @State var musicvideos: [KodiItem] = []
    /// The View
    var body: some View {
        ItemsView.List(filter) {
            ForEach(musicvideos) { musicvideo in
                let artist = kodi.getArtistInfo(artist: musicvideo.artist)
                
                /// Build a new filter for the MusicVideos.Artist View
                let newFilter = KodiFilter(
                    media: .musicvideo,
                    item: musicvideo,
                    title: artist.title,
                    subtitle: "Music Videos"
                )
                
                StackNavLink(path: "/Music Videos/Artist/\(musicvideo.id)", filter: newFilter, destination: Items(artist: artist)) {
                    Artist(artist: artist)
                }
                .buttonStyle(ButtonStyles.KodiItem(item: musicvideo))
            }
        }
        .task {
            let filter = KodiFilter(media: .musicvideo)
            let musicKodiItems = kodi.library.filter(filter)
            musicvideos = musicKodiItems
        }
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
        /// The Artist item
        let artist: KodiItem
        /// The Music Video items to show in this view
        @State var musicvideos: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List(appState.filter) {
                ForEach(musicvideos) { musicvideo in
                    Item(artist: artist, item: musicvideo.binding())
                }
            }
            .task {
                print("Music Videos task!")
                let filter = KodiFilter(media: .musicvideo, artist: artist.artist)
                let musicvideoItems = kodi.library.filter(filter)
                musicvideos = musicvideoItems
            }
        }
    }
    
    struct Item: View {
        let artist: KodiItem
        @Binding var item: KodiItem
        var body: some View {
            //StackLink(title: artist.title, destination: ItemsView.Details(item: $item)) {
                ItemsView.Item(item: $item)
            //}
            .buttonStyle(ButtonStyles.KodiItem(item: item))
            .contextMenu {
                Button(action: {
                    item.toggleWatchedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
    
}
