//
//  SeasonView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A View with all episodes from a TV show season
struct SeasonView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
//    /// The TV show
//    let tvshow: Video.Details.TVShow
//    /// The season to show in this view
//    let season: Int
    /// The episodes we want to view
    @State private var episodes: [Video.Details.Episode] = []
    /// The body of this View
    var body: some View {
        HStack(alignment: .top, spacing: 0) {

            // MARK: Diplay all episodes from the selected season
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(episodes) { episode in
                        EpisodeView(episode: episode)
                    }
                }
                //.padding(.horizontal, 100)
            }
        }
        .task(id: kodi.library.episodes) {
            episodes = kodi.library.episodes.filter( { $0.tvshowID == scene.selectedTVShow?.tvshowID && $0.season == scene.selectedSeason })
        }
    }
}
