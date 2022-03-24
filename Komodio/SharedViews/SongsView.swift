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
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack {
                    ArtView.Poster(item: album)
                        .cornerRadius(9)
                        .shadow(radius: 6)
                        .padding(6)
                    let items = kodi.media.filter { $0.media == .song && $0.albumID == album.albumID}
                    RouterLink(item: .player(items: items)) {
                        Text("Play album")
                    }
                    Text(album.description.isEmpty ? "\(album.itemsCount) tracks" : album.description)
                }
#if os(tvOS)
                .focusSection()
#endif
                ScrollView {
                    ForEach(kodi.media.filter(MediaFilter(media: .song, album: album))) { song in
                        //PlayerView.Link(item: song, destination: PlayerView(video: song.binding())) {
                            Text(song.title)
                        //}
                        .frame(width: .infinity)
                    }
                }
            }
            .padding()
        }
        .background {
            ArtView.Fanart(fanart: album.fanart)
                .macOS {$0.edgesIgnoringSafeArea(.all) }
                .tvOS { $0.edgesIgnoringSafeArea(.all) }
                .iOS { $0.edgesIgnoringSafeArea(.bottom) }
        }
        /// On macOS, give it some padding because the `TitleHeader` is on top in a `ZStack`
        .macOS { $0.padding(.top, 60)}
        .ignoresSafeArea()
    }
    func playAlbum(songs: [MediaItem]) {
        logger("Going to play songs")
//        var items: [AVPlayerItem] = []
//        
//        for song in songs {
//            items.append(AVPlayerItem(url: URL(string: song.file)!))
//        }
//        
//        audioPlayer = AVQueuePlayer(items: items)
//        audioPlayer?.play()
    }
}
