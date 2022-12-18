//
//  MusicVideoView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a Music Video
struct MusicVideoView: View {
    /// The Music Video to show
    let musicVideo: Video.Details.MusicVideo
    /// The body of the view
    var body: some View {
        VStack {
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
            .background(
                KodiArt.Fanart(item: musicVideo)
                    .scaledToFill()
                    .opacity(0.2)
            )
        }
    }
}
