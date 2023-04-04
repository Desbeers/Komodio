//
//  UpNextView+Item.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension UpNextView {

    // MARK: Up Next Item

    /// SwiftUI View for an item in the ``UpNextView`` list
    struct Item: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Poster(item: episode)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: episode)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(episode.showTitle)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(episode.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("Season \(episode.season), episode \(episode.episode)")
                        .font(.caption)
                }
                .padding(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
#endif
            }
        }
    }
}
