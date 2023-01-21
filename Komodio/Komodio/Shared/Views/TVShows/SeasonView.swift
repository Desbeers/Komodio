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
        List {
            ForEach(episodes) { episode in
                EpisodeView.Details(episode: episode)
            }
        }

#if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
#endif

    }
}
