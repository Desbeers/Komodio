//
//  SongsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 09/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI
import AVKit

struct SongsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let album: MediaItem
    
    @State var audioPlayer: AVQueuePlayer? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack {
                    ArtView.PosterDetail(item: album)
                        .cornerRadius(9)
                        .shadow(radius: 6)
                        .padding(6)
                    Button(action: {
                        playAlbum(songs: kodi.media.filter { $0.media == .song && $0.albumID == album.albumID})
                    }, label: {
                        Text("Play album")
                    })
                    Button(action: {
                        audioPlayer?.advanceToNextItem()
                    }, label: {
                        Text("Play next song")
                    })
                        .disabled(audioPlayer?.isPlaying == true ? false : true)
                    Text(album.description.isEmpty ? "\(album.itemsCount) tracks" : album.description)
                    //VideoPlayer(player: audioPlayer)
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
            }
            .padding()
        }
        /// On macOS, give it some padding because the `TitleHeader` is on top in a `ZStack`
        .macOS { $0.padding(.top, 60)}
        .ignoresSafeArea()
    }
    func playAlbum(songs: [MediaItem]) {
        logger("Going to play songs")
        var items: [AVPlayerItem] = []
        
        for song in songs {
            items.append(AVPlayerItem(url: URL(string: song.file)!))
        }
        
        audioPlayer = AVQueuePlayer(items: items)
        audioPlayer?.play()
    }
}
