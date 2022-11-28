//
//  SeasonView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View with all episodes from a TV show season
struct SeasonView: View {
    let tvshow: Video.Details.TVShow
    let season: Int
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The episodes we want to view
    @State private var episodes: [Video.Details.Episode] = []
    /// The body of this View
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            List {
                ForEach(episodes) { episode in
                    EpisodeView(episode: episode)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .task(id: kodi.library.episodes) {
            episodes = kodi.library.episodes
                .filter({ $0.tvshowID == scene.selection.tvshow?.tvshowID && $0.season == scene.selection.season })
        }
    }
}
