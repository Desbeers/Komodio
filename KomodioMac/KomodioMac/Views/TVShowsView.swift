//
//  TVShowsView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The movies in this view
    @State var tvshows: [Video.Details.TVShow] = []
    
    @State private var status: SceneState.Status = .tvshows
    
    var body: some View {
        
        ZStack {
            List(selection: $scene.selectedTVShow) {
                ForEach(tvshows) { tvshow in
                    Item(tvshow: tvshow)
                        .tag(tvshow)
                }
            }
            .offset(x: status == .episodes ? -400 : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            SeasonsView(status: $status, tvshow: $scene.selectedTVShow)
                .transition(.move(edge: .leading))
                .offset(x: status == .tvshows ? 400 : 0, y: 0)
        }
        .navigationSubtitle(scene.selectedTVShow != nil ? scene.selectedTVShow!.title : "TV Shows")
        .animation(.default, value: status)
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
        .task(id: scene.selectedTVShow) {
            if scene.selectedTVShow != nil {
                status = .episodes
            } else {
                status = .tvshows
            }

        }
    }
}

extension TVShowsView {
    
    struct Item: View {
        let tvshow: Video.Details.TVShow
        var body: some View {
            HStack {
                KodiArt.Poster(item: tvshow)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                VStack(alignment: .leading) {
                    Text(tvshow.title)
                        .font(.headline)
                    Text(tvshow.genre.joined(separator: "∙"))
                    Text(tvshow.premiered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .watchStatus(of: tvshow)
            }
        }
    }
}

extension TVShowsView {
    
    struct Details: View {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        var body: some View {
            VStack {
                if let tvshow = scene.selectedTVShow {
                    Text(tvshow.title)
                        .font(.largeTitle)
                } else {
                    Text("TV shows")
                        .font(.largeTitle)
                }
            }
            .animation(.default, value: scene.selectedTVShow)
        }
    }
}

