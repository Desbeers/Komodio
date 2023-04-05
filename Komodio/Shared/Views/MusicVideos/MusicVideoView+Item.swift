//
//  MusicVideoView+Item.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MusicVideoView {

    // MARK: Music Video Item

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
                Text(item.id)
                    .font(.headline)
#endif
            }
        }
    }
}
