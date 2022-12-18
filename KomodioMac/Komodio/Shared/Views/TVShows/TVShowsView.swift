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
    @State var selectedTVShow: Video.Details.TVShow?
    /// The loading state of the view
    @State private var state: Parts.State = .loading
    /// The body of the view
    var body: some View {
        VStack {
            switch state {
            case .loading:
                Text(Router.tvshows.loading)
            case .empty:
                Text(Router.tvshows.empty)
            case .ready:
                content
            case .offline:
                state.offlineMessage
            }
        }
        .animation(.default, value: selectedTVShow)
        .task(id: kodi.library.tvshows) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.tvshows.isEmpty {
                state = .empty
            } else {
                tvshows = kodi.library.tvshows
                state = .ready
            }
        }
        .task(id: selectedTVShow) {
            if let selectedTVShow {
                scene.details = .tvshow(tvshow: selectedTVShow)
            } else {
                scene.navigationSubtitle = Router.tvshows.label.title
            }
        }
    }
    /// The content of the view
    var content: some View {
        ZStack {
            List(selection: $selectedTVShow) {
                ForEach(tvshows) { tvshow in
                    Item(tvshow: tvshow)
                        .modifier(Modifiers.TVShowsViewItem(tvshow: tvshow, selectedTVShow: $selectedTVShow))
                }
            }
            .offset(x: selectedTVShow != nil ? -ContentView.columnWidth : 0, y: 0)
            .modifier(Modifiers.ContentListStyle())
            SeasonsView(tvshow: $selectedTVShow)
                    .transition(.move(edge: .leading))
                    .offset(x: selectedTVShow != nil ? 0 : ContentView.columnWidth, y: 0)
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
                    .frame(width: MainView.posterSize.width, height: MainView.posterSize.height)
                #if os(macOS)
                VStack(alignment: .leading) {
                    Text(tvshow.title)
                        .font(.headline)
                    Text(tvshow.genre.joined(separator: "∙"))
                    Text(tvshow.year.description)
                        .font(.caption)
                }
                #endif
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .watchStatus(of: tvshow)
        }
    }
}
