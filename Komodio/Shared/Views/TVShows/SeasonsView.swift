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
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Episode] = []
    /// The optional selected season (macOS)
    @State private var selectedSeason: Int?
    /// The selected season tab (tvOS)
    @State private var selectedTab: Int = -1
    /// The subtitle (tvOS)
    private var subtitle: String {
        switch selectedTab {
        case -1:
            return "TV Show info"
        case 0:
            return "Specials"
        default:
            return "Season \(selectedTab)"
        }
    }

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .task(id: tvshow) {
                getTVShowSeasons()
            }
            .task(id: kodi.library.episodes) {
                getTVShowSeasons()
                setSeasonDetails()
            }
            .task(id: selectedSeason) {
                setSeasonDetails()
            }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            LazyVStack {
                KodiArt.Fanart(item: tvshow)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                ForEach(seasons) { season in
                    Button(
                        action: {
                            selectedSeason = season.season
                        },
                        label: {
                            SeasonView.Item(season: season)
                        }
                    )
                    .buttonStyle(.listButton(selected: selectedSeason == season.season))
                    Divider()
                }
            }
            .padding()
        }
#endif

#if os(tvOS) || os(iOS)
        /// Show seasons on page tabs
        ContentView.Wrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(title: tvshow.title, subtitle: subtitle)
            },
            content: {
                VStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            Button(
                                action: {
                                    selectedTab = -1
                                },
                                label: {
                                    Text("Info")
                                        .font(.caption)
                                })
                            .buttonStyle(.listButton(selected: selectedTab == -1))
                            .padding()
                            ForEach(seasons) { season in
                                Button(
                                    action: {
                                        selectedTab = season.season
                                    },
                                    label: {
                                        Text(season.season == 0 ? "Specials" : "Season \(season.season)")
                                            .font(.caption)
                                    })
                                .buttonStyle(.listButton(selected: selectedTab == season.season))
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                        .padding(4)
                                        .opacity(season.playcount == 0 ? 1 : 0)
                                }
                                .padding()
                            }
                        }
                    }
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    .backport.focusSection()
                    switch selectedTab {
                    case -1:
                        TVShowView.Details(tvshow: tvshow)
                            .backport.focusSection()
                    default:
                        HStack {
                            /// Display the season cover
                            if let season = seasons.first(where: { $0.season == selectedTab }) {
                                VStack {
                                    KodiArt.Poster(item: season)
                                        .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                                        .cornerRadius(10)
                                        .watchStatus(of: season)
                                }
                                .frame(maxHeight: .infinity)
                            }
                            SeasonView(
                                tvshow: tvshow,
                                episodes: episodes.filter { $0.season == selectedTab }
                            )
                        }
                        .backport.focusSection()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .animation(.default, value: selectedTab)
            }
        )
#endif
    }

    // MARK: Private functions

    /// Get all seasons of a TV show
    private func getTVShowSeasons() {
        episodes = kodi.library.episodes
            .filter { $0.tvshowID == tvshow.tvshowID }
        /// Filter the episodes to get the seasons
        var seasons = episodes.unique { $0.season }
        /// Find the playcount of the season
        for index in seasons.indices {
            let unwatched = episodes
                .filter { $0.season == seasons[index].season && $0.playcount == 0 }
                .count
            seasons[index].playcount = unwatched == 0 ? 1 : 0
            seasons[index].resume.position = 0
        }
        self.seasons = seasons
    }

    /// Set the details of a selected season
    private func setSeasonDetails() {
        if let selectedSeason {
            let episodes = self.episodes
                .filter { $0.season == selectedSeason }
            scene.details = .season(tvshow: tvshow, episodes: episodes)
        }
    }
}
