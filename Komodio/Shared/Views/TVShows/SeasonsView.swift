//
//  SeasonsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Seasons View

/// SwiftUI `View` for all Seasons of a TV show (shared)
struct SeasonsView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The seasons to show in this view
    @State private var seasons: [Video.Details.Season] = []

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
        /// Initial action when showing the `View`
            .task(id: tvshow) {
                getTVShowSeasons()
            }
        /// Action when the episodes of the Kodi library are updated
            .onChange(of: kodi.library.episodes) {
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
                        scene.detailSelection = .tvshow(tvshow: tvshow)
                    },
                    label: {
                        KodiArt.Fanart(item: tvshow)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                    }
                )
                .buttonStyle(.plain)
                .padding(StaticSetting.cellPadding)
                ForEach(seasons) { season in
                    CollectionView.Cell(item: season, collectionStyle: .asList)
                }
            }
        }
#endif

#if canImport(UIKit)
        /// `View` for tvOS and iOS
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: tvshow.title,
                    subtitle: scene.detailSelection.item.description
                )
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    ScrollView {
                        LazyVStack {
                            CollectionView.Cell(item: tvshow, collectionStyle: .asGrid)
                            ForEach(seasons) { season in
                                CollectionView.Cell(item: season, collectionStyle: .asList)
                            }
                        }
                        .padding(.vertical, StaticSetting.detailPadding)
                    }
                    .frame(width: StaticSetting.contentWidth, alignment: .leading)
                    .backport.focusSection()
                    DetailView()
                        .padding(.leading, StaticSetting.detailPadding)
                        .frame(maxWidth: .infinity)
                }
            },
            buttons: {}
        )
#endif
    }

    // MARK: Private functions

    /// Get all seasons of a TV show
    private func getTVShowSeasons() {
        let allEpisodes = kodi.library.episodes
            .filter { $0.tvshowID == tvshow.tvshowID }
        seasons = allEpisodes.swapEpisodesForSeasons(tvshow: tvshow)
        /// Update the season details of the optional selected season
        if
            let season = scene.detailSelection.item.kodiItem,
            season.media == .season,
            let update = seasons.first(where: { $0.id == season.id }) {
            /// Update the selected season
            scene.detailSelection = .season(season: update)
        }
    }
}
