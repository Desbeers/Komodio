//
//  SeasonView+Item.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension SeasonView {

    // MARK: Season Item

    /// SwiftUI View for a season item
    struct Item: View {
        /// The Season
        let season: Video.Details.Season

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Poster(item: season)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)

                    .padding(.trailing)
                Text(season.title)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .watchStatus(of: season)
        }
    }
}
