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
    /// The optional selected season (macOS)
    @State private var selectedSeason: Int?
    /// The selected season tab (tvOS)
    @State private var selectedTab: Int = -1

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
        /// Show seasons on page tabs
        /// - Note: Shown in 'page' style because SwiftUI can only show 7 tabs when using the 'normal' style
        ///         and there might be more seasons
        if !seasons.isEmpty {
            TabView(selection: $selectedTab) {
                    TVShowView.Details(tvshow: tvshow)
                    .focusable()
                    .focusSection()
                    .tag(-1)
                /// It looks like `TabView` is ignoring the custom safe areas
                    .padding(.leading, KomodioApp.sidebarCollapsedWidth / 1.2)
                ForEach(seasons) { season in
                    HStack {
                        /// Display the season cover
                        VStack {
                            Text(tvshow.title)
                                .font(.title3)
                            Text(season.season == 0 ? "Specials" : "Season \(season.season)")
                            KodiArt.Poster(item: season)
                                .frame(width: 400, height: 600)
                                .cornerRadius(10)
                                .watchStatus(of: season)
                        }
                        /// It looks like `TabView` is ignoring the custom safe areas
                        .padding(.leading, KomodioApp.sidebarCollapsedWidth / 1.2)
                        .padding(.trailing, 100)
                        SeasonView(tvshow: tvshow, episodes: episodes.filter({$0.season == season.season }))
                    }
                    .tag(season.season)
                }
            }
            .tabViewStyle(.page)
        }
#endif

    }

    // MARK: Private functions

    /// Get all seasons of a TV show
    private func getTVShowSeasons() {
        if tvshow.media == .tvshow {
            scene.details = .tvshow(tvshow: tvshow)
            episodes = kodi.library.episodes
                .filter({$0.tvshowID == tvshow.tvshowID})
            /// Filter the episodes to get the seasons
            var seasons = episodes.unique { $0.season }
            /// Find the playcount of the season
            for index in seasons.indices {
                let unwatched = episodes.filter({$0.season == seasons[index].season && $0.playcount == 0}).count
                seasons[index].playcount = unwatched == 0 ? 1 : 0
                seasons[index].resume.position = 0
            }
            self.seasons = seasons
        } else {
            selectedSeason = nil
        }
    }

    /// Set the details of a selected season
    private func setSeasonDetails() {
        if let selectedSeason {
            let episodes = self.episodes.filter({$0.season == selectedSeason })
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
