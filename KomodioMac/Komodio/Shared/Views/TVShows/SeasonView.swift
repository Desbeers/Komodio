//
//  SeasonView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for one Season of a TV show
struct SeasonView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The Episodes to show
    let episodes: [Video.Details.Episode]
    /// The body of this View
    var body: some View {
        List {
            ForEach(episodes) { episode in
                EpisodeView(episode: episode)
            }
        }
#if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
#endif
    }
}
