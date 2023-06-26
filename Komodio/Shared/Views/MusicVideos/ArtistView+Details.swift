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

    /// SwiftUI View for Artist details
    struct Details: View {
        /// The Artist
        let artist: Audio.Details.Artist

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
#if os(macOS) || os(iOS)
            DetailWrapper(title: artist.artist) {
                VStack {
                    KodiArt.Fanart(item: artist)
                        .fanartStyle(item: artist)
                        .padding(.bottom)
                    PartsView.TextMore(item: artist)
                }
                .detailsFontStyle()
            }
#endif

#if os(tvOS)
            VStack {
                KodiArt.Fanart(item: artist)
                    .fanartStyle(item: artist)
                    .frame(width: KomodioApp.fanartSize.width, height: KomodioApp.fanartSize.height)
                    .padding(.bottom)
                PartsView.TextMore(item: artist)
            }
            .detailsFontStyle()
#endif
        }
    }
}
