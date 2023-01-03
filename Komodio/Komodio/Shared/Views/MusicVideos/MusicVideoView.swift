//
//  MusicVideoView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

enum MusicVideoView {

    static func updateMusicVideo(musicVideo: Video.Details.MusicVideo) -> Video.Details.MusicVideo? {
        if let update = KodiConnector.shared.library.musicVideos.first(where: {$0.id == musicVideo.id}), update != musicVideo {
            return update
        }
        return nil
    }
}

extension MusicVideoView {

    /// SwiftUI View for a Music Video details
    struct Details: View {
        /// The Music Video
        @State var musicVideo: Video.Details.MusicVideo
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The body of the View
        var body: some View {
            VStack {
                Text(musicVideo.title)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                KodiArt.Fanart(item: musicVideo)
                    .watchStatus(of: musicVideo)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Buttons.Player(item: musicVideo)
                Text(musicVideo.plot)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(file: musicVideo.fanart)
            .task(id: kodi.library.musicVideos) {
                if let update = MusicVideoView.updateMusicVideo(musicVideo: musicVideo) {
                    print("Update")
                    musicVideo = update
                }
            }
            .animation(.default, value: musicVideo)
        }
    }
}
