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

    /// Update a Music Video
    /// - Parameter musicVideo: The music video to update
    /// - Returns: If update is found, the updated Music Video, else `nil`
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

        // MARK: Body of the View

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
            .background(item: musicVideo)
            .task(id: kodi.library.musicVideos) {
                if let update = MusicVideoView.updateMusicVideo(musicVideo: musicVideo) {
                    musicVideo = update
                }
            }
            .animation(.default, value: musicVideo)
        }
    }
}
