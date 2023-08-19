//
//  ArtistView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension ArtistView {

    // MARK: Artist Details

    /// SwiftUI `View` for details of an `Artist`
    struct Details: View {
        /// The Artist
        let artist: Audio.Details.Artist

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: StaticSetting.platform == .tvOS ? nil : artist.id,
                title: StaticSetting.platform == .macOS ? artist.artist : nil
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            VStack {
                KodiArt.Fanart(item: artist)
                    .fanartStyle(item: artist)
                    .padding(.bottom)
                PartsView.TextMore(item: artist)
            }
        }
    }
}
