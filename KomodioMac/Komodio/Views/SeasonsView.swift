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
        .toolbar{
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

extension SeasonsView {
    
    struct Details: View {
        let tvshow: Video.Details.TVShow
        let season: Int
        
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The SceneState model
        //@EnvironmentObject var scene: SceneState
        /// The episodes we want to view
        @State private var episodes: [Video.Details.Episode] = []
        /// The body of this View
        var body: some View {
            List {
                ForEach(episodes) { episode in
                    Episode(episode: episode)
                }
            }
//            HStack(alignment: .top, spacing: 0) {
//                ScrollView(.vertical, showsIndicators: false) {
//                    LazyVStack(spacing: 0) {
//                        ForEach(episodes) { episode in
//                            Episode(episode: episode)
//                        }
//                    }
//                    //.padding(.horizontal, 100)
//                }
//            }
            .task(id: kodi.library.episodes) {
                episodes = kodi.library.episodes
                    .filter( { $0.tvshowID == tvshow.tvshowID && $0.season == season })
            }
        }
    }
}

extension SeasonsView {
    
    /// A View with an episode from a TV show season
    struct Episode: View {
        let episode: Video.Details.Episode
        /// The body of this View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Art(file: episode.thumbnail)
                    .watchStatus(of: episode)
                    .frame(width: 320, height: 180)
                    .overlay(alignment: .bottom) {
                        Buttons.Player(item: episode)
                    }
                    .padding()
                VStack(alignment: .leading) {
                    Text(episode.title)
                    Text(episode.plot)
                        .font(.caption2)
                        .lineLimit(5)
                }
            }
            .background(.thinMaterial)
        }
    }
}
