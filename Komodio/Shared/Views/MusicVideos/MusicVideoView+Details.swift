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
        let musicVideo: Video.Details.MusicVideo

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? false : true,
                part: KomodioApp.platform == .macOS ? false : true,
                title: musicVideo.title
            ) {
                content
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
