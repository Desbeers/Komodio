//
//  SeasonsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Seasons View

/// SwiftUI View for all Seasons of a TV show (shared)
struct SeasonsView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The selected scene
    @State private var selectedSeason: Video.Details.Season
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Season] = []
    /// The TV show info 'season'
    private let tvShowInfo: Video.Details.Season
    /// Init the `View`
    public init(tvshow: Video.Details.TVShow) {
        self.tvshow = tvshow
        self.tvShowInfo = Video.Details.Season(tvshow: tvshow, season: -1, playcount: 1)
        self.selectedSeason = self.tvShowInfo
    }

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .task(id: tvshow) {
                getTVShowSeasons()
            }
            .onChange(of: kodi.library.episodes) { _ in
                getTVShowSeasons()
            }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            LazyVStack {
                Button(
                    action: {
                        setSeasonDetails(tvShowInfo)
                    },
                    label: {
                        KodiArt.Fanart(item: tvshow)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }
                )
                .buttonStyle(.plain)
                ForEach(seasons) { season in
                    Button(
                        action: {
                            setSeasonDetails(season)
                        },
                        label: {
                            SeasonView.Item(season: season)
                        }
                    )
                    .buttonStyle(.kodiItemButton(kodiItem: season))
                    Divider()
                }
            }
            .padding()
        }
#endif

#if os(tvOS) || os(iOS)
        /// Show seasons on page tabs
        ContentView.Wrapper(
            scroll: KomodioApp.platform == .tvOS ? false : true,
            header: {
                PartsView.DetailHeader(title: tvshow.title, subtitle: scene.details.item.description)
            },
            content: {
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(seasons) { season in
                                Button(
                                    action: {
                                        setSeasonDetails(season)
                                    },
                                    label: {
                                        Text(season.title)
                                            .padding(KomodioApp.platform == .tvOS ? 30 : 15)
                                            .overlay(alignment: .topTrailing) {
                                                Image(systemName: "star.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.yellow)
                                                    .opacity(season.playcount == 0 ? 1 : 0)
                                            }
                                    }
                                )
                                .buttonStyle(.tabButton(selected: season.season == selectedSeason.season))
                                .padding()
                            }
                        }
                    }
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    .backport.focusSection()
                    DetailView()
                        .backport.focusSection()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .animation(.default, value: scene.details)
            }
        )
#endif
    }

    // MARK: Private functions

    /// Get all seasons of a TV show
    private func getTVShowSeasons() {
        var seasons: [Video.Details.Season] = []
        let allEpisodes = kodi.library.episodes
            .filter { $0.tvshowID == tvshow.tvshowID }
#if !os(macOS)
        /// Start with the TV show info season for tvOS and iOS
        seasons.append(tvShowInfo)
#endif
        /// Filter the episodes to get the seasons
        let allSeasons = allEpisodes.unique { $0.season }
        /// Find the playcount of the season
        for season in allSeasons {
            let unwatched = allEpisodes
                .filter { $0.season == season.season && $0.playcount == 0 }
                .count
            seasons.append(
                .init(
                    tvshow: tvshow,
                    season: season.season,
                    episodes: allEpisodes.filter { $0.season == season.season },
                    playcount: unwatched == 0 ? 1 : 0,
                    art: season.art
                )
            )
        }
        self.seasons = seasons
        /// Update the season details of the optional selected season
        if let update = seasons.first(where: { $0.season == selectedSeason.season }) {
            setSeasonDetails(update)
        }
    }

    /// Set the details of a selected season
    private func setSeasonDetails(_ season: Video.Details.Season) {
        selectedSeason = season
        switch season.season {
        case -1:
            scene.details = .tvshow(tvshow: tvshow)
        default:
            scene.details = .season(season: season)
        }
    }
}
