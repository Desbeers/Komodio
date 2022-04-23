//
//  SongsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import AVKit

struct SongsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let album: MediaItem
    
    //@State var audioPlayer: AVQueuePlayer? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            //Spacer()
            HStack {
                VStack {
                    ArtView.Poster(item: album)
                        .cornerRadius(9)
                        .shadow(radius: 6)
                        .padding(6)
                    let items = kodi.media.filter { $0.media == .song && $0.albumID == album.albumID}
                    RouterLink(item: .player(items: items)) {
                        Text("Play album")
                    }
                    Text(album.description.isEmpty ? "\(items.count) tracks" : album.description)
                }
                VStack(alignment: .center) {
                    ScrollView {
                        ForEach(kodi.media.filter(MediaFilter(media: .song, album: album))) { song in
                            Text(song.title)
                        }
                    }
                    .frame(maxHeight: 350)
                }
                .background(.green)
            }
            .padding(.top, 200)
            //Spacer()
        }
    }
}
