//
//  TVShowsView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The tv shows in this view
    @State var tvshows: [Video.Details.TVShow] = []
    /// The body of the view
    var body: some View {
        ZStack {
            List(selection: $scene.selection.tvshow) {
                ForEach(tvshows) { tvshow in
                    Item(tvshow: tvshow)
                        .tag(tvshow)
                }
            }
            .offset(x: scene.selection.route == .season ? -AppState.contentColumnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
                SeasonsView()
                    .transition(.move(edge: .leading))
                    .offset(x: scene.selection.route == .season ? 0 : AppState.contentColumnWidth, y: 0)
        }
        .navigationSubtitle(scene.selection.tvshow != nil ? scene.selection.tvshow!.title : "TV Shows")
        .animation(.default, value: scene.selection.route)
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
        .task(id: scene.selection.tvshow) {
            scene.selection.route = scene.selection.tvshow == nil ? .tvshows : .season
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
