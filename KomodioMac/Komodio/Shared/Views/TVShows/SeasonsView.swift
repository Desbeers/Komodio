//
//  SeasonsView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Seasons of a TV show
struct SeasonsView: View {

    @Binding var tvshow: Video.Details.TVShow?

    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Episode] = []
    /// The optional selected season
    @State private var selectedSeason: Int?
    /// The body of the View
    var body: some View {
        content
        .task(id: tvshow) {
            getTVShowSeasons()
        }
        .task(id: selectedSeason) {
            setSeasonDetails()
        }
        .task(id: kodi.library.episodes) {
            getTVShowSeasons()
            setSeasonDetails()
        }
    }
#if os(macOS)
    /// The content of the View
    var content: some View {
        VStack {
            List(selection: $selectedSeason) {
                ForEach(seasons) { season in
                    Item(season: season)
                        .tag(season.season)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar {
            if tvshow != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        tvshow = nil
                        /// We might came from the search page
                        if scene.sidebarSelection == .search {
                            scene.contentSelection = .search
                            scene.details = .tvshows
                        } else {
                            scene.details = .tvshows
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
    }
#endif

#if os(tvOS)
    /// The content of the View
    var content: some View {
        HStack {
            List(selection: $selectedSeason) {
                ForEach(seasons) { season in
                    Button(action: {
                        selectedSeason = season.season
                    }, label: {
                        Item(season: season)
                            .foregroundColor(season.season == selectedSeason ? .blue : .primary)
                    })
                }
            }
            .frame(width: 500)
            DetailView()
        }
        .buttonStyle(.card)
        .setSafeAreas()
    }
#endif

    func getTVShowSeasons() {
        if let tvshow {
            scene.details = .tvshow(tvshow: tvshow)
            seasons = kodi.library.episodes
                .filter({$0.tvshowID == tvshow.tvshowID}).unique { $0.season }
        }
    }

    func setSeasonDetails() {
        if let tvshow, let selectedSeason {
            let episodes = kodi.library.episodes
                .filter({ $0.tvshowID == tvshow.tvshowID && $0.season == selectedSeason })
            scene.details = .season(tvshow: tvshow, episodes: episodes)
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
