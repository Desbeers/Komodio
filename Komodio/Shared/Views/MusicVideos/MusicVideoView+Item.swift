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
        /// The `KodiItem`
        let item: any KodiItem

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
                KodiArt.Poster(item: item)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: item)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text("Year: \(item.year.description)")
                }
#endif
            }
        }
    }
}
