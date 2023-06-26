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

    /// SwiftUI View for Music Video details
    struct Details: View {
        /// The Music Video
        let musicVideo: Video.Details.MusicVideo

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            DetailView.Wrapper(title: musicVideo.title) {
                VStack {
                    KodiArt.Fanart(item: musicVideo)
                        .fanartStyle(item: musicVideo)
                    Buttons.Player(item: musicVideo)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .backport.focusSection()
                    PartsView.TextMore(item: musicVideo)
                }
                .backport.focusSection()
                .detailsFontStyle()
            }
        }
    }
}
