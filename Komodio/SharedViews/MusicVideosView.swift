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
                StackNavLink(path: "/Movies/Details/\(musicvideo.id)", filter: filter, destination: DetailsView(item: musicvideo.binding())) {
                    ItemsView.Item(item: musicvideo.binding())
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
