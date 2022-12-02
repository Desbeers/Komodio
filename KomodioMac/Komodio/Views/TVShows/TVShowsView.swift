//
//  TVShowsView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all TV shows
struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The TV shows in this view
    @State var tvshows: [Video.Details.TVShow] = []
    /// The optional selected TV show
    @State private var tvshow: Video.Details.TVShow?
    /// The body of the view
    var body: some View {
        ZStack {
            List(selection: $tvshow) {
                ForEach(tvshows) { tvshow in
                    Item(tvshow: tvshow)
                        .tag(tvshow)
                }
            }
            .offset(x: tvshow != nil ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            SeasonsView(tvshow: $tvshow)
                    .transition(.move(edge: .leading))
                    .offset(x: tvshow != nil ? 0 : ContentView.columnWidth, y: 0)
        }
        .animation(.default, value: tvshow)
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
        .task(id: tvshow) {
            if let tvshow {
                scene.details = .tvshow(tvshow: tvshow)
            } else {
                scene.navigationSubtitle = Router.tvshows.label.title
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
