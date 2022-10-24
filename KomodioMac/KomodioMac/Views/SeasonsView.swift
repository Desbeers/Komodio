//
//  SeasonsView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SeasonsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The TV show
    //let tvshow: Video.Details.TVShow
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Episode] = []
    
    @Binding var status: SceneState.Status
    @Binding var tvshow: Video.Details.TVShow?
    
    var body: some View {
        VStack {
            List(selection: $scene.selectedSeason) {
                ForEach(seasons) { season in
                    Item(season: season)
                        .tag(season.season)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar{
            if scene.selectedTVShow != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        scene.selectedSeason = nil
                        scene.selectedTVShow = nil
                        status = .tvshows
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .onChange(of: tvshow) { tvshow in
            if let tvshow = self.tvshow {
                seasons = kodi.library.episodes
                    .filter({$0.tvshowID == tvshow.tvshowID}).unique { $0.season }
            }
        }
    }
}

extension SeasonsView {
    struct Item: View {
        let season: Video.Details.Episode
        var body: some View {
            HStack {
                KodiArt.Poster(item: season)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                Text(season.season == 0 ? "Specials" : "Season \(season.season)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .watchStatus(of: season)
        }
    }
}
