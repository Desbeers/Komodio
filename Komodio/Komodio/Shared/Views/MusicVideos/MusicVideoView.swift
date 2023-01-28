//
//  MusicVideoView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single Music Video (shared)
enum MusicVideoView {
    // Just a Namespace
}

extension MusicVideoView {

    /// SwiftUI View for a Music Video details
    struct Details: View {
        /// The Music Video
        let musicVideo: Video.Details.MusicVideo

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
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
            .detailsFontStyle()
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(item: musicVideo)
#endif

#if os(tvOS)
            VStack {
                Text(musicVideo.title)
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                KodiArt.Fanart(item: musicVideo)
                    .watchStatus(of: musicVideo)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Buttons.Player(item: musicVideo)
                Text(musicVideo.plot)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(item: musicVideo)
#endif

        }
    }
}
