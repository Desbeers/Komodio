//
//  SeasonView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for one Season of a TV show (shared)
struct SeasonView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The Episodes to show
    let episodes: [Video.Details.Episode]

    // MARK: Body of the View

    /// The body of this View
    var body: some View {

#if os(macOS)
        List {
            ForEach(episodes) { episode in
                EpisodeView.Item(episode: episode)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
#endif

#if os(tvOS)
        List {
            ForEach(episodes) { episode in
                EpisodeView.Item(episode: episode)
            }
        }
#endif

    }
}

extension SeasonView {

    // MARK: Season item

    /// SwiftUI View for a season item
    struct Item: View {
        /// The Season
        let season: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Poster(item: season)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.trailing)
                Text(season.season == 0 ? "Specials" : "Season \(season.season)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .watchStatus(of: season)
        }
    }
}
