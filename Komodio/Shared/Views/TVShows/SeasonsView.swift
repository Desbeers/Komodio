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
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Season] = []
    /// The TV show info 'season'
    private let tvShowInfo: Video.Details.Season
    /// Init the `View`
    public init(tvshow: Video.Details.TVShow) {
        self.tvshow = tvshow
        self.tvShowInfo = Video.Details.Season(tvshow: tvshow, season: -1, playcount: 1)
    }

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .animation(.default, value: scene.details)
        /// Initial action when showing the `View`
            .task(id: tvshow) {
                getTVShowSeasons()
            }
        /// Action when the episodes of the Kodi library are updated
            .onChange(of: kodi.library.episodes) { _ in
                getTVShowSeasons()
            }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {

#if os(macOS)
        /// `View` for macOS
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

#if canImport(UIKit)
        /// `View` for tvOS and iOS
        ContentView.Wrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(title: tvshow.title, subtitle: scene.details.item.description)
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    ScrollView {
                        LazyVStack {
                            Button(
                                action: {
                                    setSeasonDetails(tvShowInfo)
                                },
                                label: {
                                    KodiArt.Poster(item: tvshow)
                                        .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(10)
                                }
                            )
                            .buttonStyle(.kodiItemButton(kodiItem: tvshow))
                            .padding(KomodioApp.posterSize.width / 10)
                            ForEach(seasons) { season in
                                Button(
                                    action: {
                                        setSeasonDetails(season)
                                    },
                                    label: {
                                        SeasonView.Item(season: season)
                                            .frame(width: KomodioApp.posterSize.width)
                                    }
                                )
                                .buttonStyle(.kodiItemButton(kodiItem: season))
                                .padding(KomodioApp.posterSize.width / 10)
                            }
                        }
                        .padding(.vertical, KomodioApp.contentPadding)
                    }
                    .frame(width: KomodioApp.columnWidth, alignment: .leading)
                    .backport.focusSection()
                    DetailView()
                        .padding(.leading, KomodioApp.contentPadding)
                        .frame(maxWidth: .infinity)
                }
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
        if let selectedSeason = scene.details.item.kodiItem,
            let update = seasons.first(where: { $0.id == selectedSeason.id }) {
            setSeasonDetails(update)
        }
    }

    /// Set the details of a selected season
    private func setSeasonDetails(_ season: Video.Details.Season) {
        switch season.season {
        case -1:
            scene.details = .tvshow(tvshow: tvshow)
        default:
            scene.details = .season(season: season)
        }
    }
}
