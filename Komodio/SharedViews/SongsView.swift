//
//  SongsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 09/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SongsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let album: MediaItem
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack {
                    ArtView.PosterDetail(item: album)
                        .cornerRadius(9)
                        .shadow(radius: 6)
                        .padding(6)
                    HStack {
                        PlayerView.Link(item: album, destination: PlayerView(video: album.binding())) {
                            Text("Play album")
                        }
                        PlayerView.Link(item: album, destination: PlayerView(video: album.binding())) {
                            Text("Shuffle album")
                        }
                    }
                    Text(album.description.isEmpty ? "\(album.itemsCount) tracks" : album.description)
                }
#if os(tvOS)
                .focusSection()
#endif
                ScrollView {
                    ForEach(kodi.media.filter(MediaFilter(media: .song, album: album))) { song in
                        PlayerView.Link(item: song, destination: PlayerView(video: song.binding())) {
                            Text(song.title)
                        }
                        .frame(width: .infinity)
                    }
                }
//#if os(tvOS)
//                .focusSection()
//#endif
            }
            .padding()
        }
        /// On macOS, give it some padding because the `TitleHeader` is on top in a `ZStack`
        .macOS { $0.padding(.top, 60)}
        .ignoresSafeArea()
        //.buttonStyle(ButtonStyles.HomeItem())
        //}
        
    }
}
