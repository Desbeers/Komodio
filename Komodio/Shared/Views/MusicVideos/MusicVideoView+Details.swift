//
//  MusicVideoView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MusicVideoView {

    // MARK: Music Video Details

    /// SwiftUI `View` for details of a `Music Video`
    struct Details: View {
        /// The `Music Video` to show
        let selectedMusicVideo: Video.Details.MusicVideo
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The state values of the `Music Video`
        @State private var musicVideo: Video.Details.MusicVideo
        /// Init the `View`
        init(musicVideo: Video.Details.MusicVideo) {
            self.selectedMusicVideo = musicVideo
            self._musicVideo = State(initialValue: musicVideo)
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? nil : musicVideo.id,
                part: KomodioApp.platform == .macOS ? false : true,
                title: musicVideo.title
            ) {
                content
                    .animation(.default, value: musicVideo)
                /// Update the state to the new selection
                    .task(id: selectedMusicVideo) {
                        musicVideo = selectedMusicVideo
                    }
                /// Update the state from the library
                    .task(id: kodi.library.musicVideos) {
                        if let update = MusicVideoView.update(musicVideo: musicVideo) {
                            musicVideo = update
                        }
                    }
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            VStack {
                KodiArt.Fanart(item: musicVideo)
                    .fanartStyle(item: musicVideo)
                Buttons.Player(item: musicVideo)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .backport.focusSection()
                PartsView.TextMore(item: musicVideo)
            }
        }
    }
}
