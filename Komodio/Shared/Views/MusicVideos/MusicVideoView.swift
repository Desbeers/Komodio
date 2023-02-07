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

    // MARK: Music Video item

    /// SwiftUI View for a Music Video item
    ///
    /// - This can be an album or a music video
    struct Item: View {
        /// The ``MediaItem``
        let item: MediaItem

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
                KodiArt.Poster(item: item.item)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: item.item)

#if os(macOS)
                Text(item.media == .musicVideo ? item.item.title : item.item.details)
                    .font(.headline)
#endif

            }
        }
    }
}

extension MusicVideoView {

    // MARK: Music Video details

    /// SwiftUI View for Music Video details
    struct Details: View {
        /// The Music Video
        let musicVideo: Video.Details.MusicVideo

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                PartsView.DetailHeader(title: musicVideo.title)
                KodiArt.Fanart(item: musicVideo)
                    .fanartStyle(item: musicVideo)
#if os(tvOS)
                    .frame(width: KomodioApp.fanartSize.width, height: KomodioApp.fanartSize.height)
#endif
                Buttons.Player(item: musicVideo)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .focusSection()
                PartsView.TextMore(item: musicVideo)
            }
            .focusSection()
            .detailsFontStyle()
            .detailsWrapper()
            .background(item: musicVideo)
        }
    }
}
