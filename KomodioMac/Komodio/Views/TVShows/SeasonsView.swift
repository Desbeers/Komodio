//
//  SeasonsView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct SeasonsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Episode] = []
    /// The body of the view
    var body: some View {
        VStack {
            List(selection: $scene.selection.season) {
                ForEach(seasons) { season in
                    Item(season: season)
                        .tag(season.season)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar {
            if scene.selection.tvshow != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        scene.selection = SceneState.Selection(route: .tvshows)
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .task(id: scene.selection.tvshow) {
            if let tvshow = scene.selection.tvshow {
                seasons = kodi.library.episodes
                    .filter({$0.tvshowID == tvshow.tvshowID}).unique { $0.season }
            }
            
        }
    }
}

private extension SeasonsView {
    
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
