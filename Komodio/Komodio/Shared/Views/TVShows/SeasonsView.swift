//
//  SeasonsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Seasons of a TV show (shared)
struct SeasonsView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Episode] = []
    /// The optional selected season
    @State private var selectedSeason: Int?

    // MARK: Body of the View

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

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)

        VStack {
            List(selection: $selectedSeason) {
                KodiArt.Fanart(item: tvshow)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                ForEach(seasons) { season in
                    Item(season: season)
                        .tag(season.season)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
#endif

#if os(tvOS)
        HStack {
            List {
                ForEach(seasons) { season in
                    Button(action: {
                        selectedSeason = season.season
                    }, label: {
                        Item(season: season)
                            .foregroundColor(season.season == selectedSeason ? Color("AccentColor") : .primary)
                    })
                }
            }
            .frame(width: 340)
            DetailView()
                .frame(maxWidth: .infinity)
                .focusSection()
        }
        .animation(.default, value: selectedSeason)
        .buttonStyle(.card)
#endif

    }

    // MARK: Private functions

    /// Get all seasons of a TV show
    private func getTVShowSeasons() {
        if tvshow.media == .tvshow {
            scene.details = .tvshow(tvshow: tvshow)
            seasons = kodi.library.episodes
                .filter({$0.tvshowID == tvshow.tvshowID}).unique { $0.season }
        } else {
            selectedSeason = nil
        }
    }

    /// Set the details of a selected season
    private func setSeasonDetails() {
        if let selectedSeason {
            let episodes = kodi.library.episodes
                .filter({ $0.tvshowID == tvshow.tvshowID && $0.season == selectedSeason })
            scene.details = .season(tvshow: tvshow, episodes: episodes)
        }
    }
}

// MARK: Extensions

private extension SeasonsView {

    /// SwiftUI View for a season in ``SeasonsView``
    struct Item: View {
        /// The Season
        let season: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Poster(item: season)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.trailing)
                Text(season.season == 0 ? "Specials" : "Season \(season.season)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .watchStatus(of: season)
        }
    }
}
