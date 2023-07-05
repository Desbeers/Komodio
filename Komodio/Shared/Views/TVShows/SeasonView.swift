//
//  SeasonView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Season View

/// SwiftUI View for one Season of a TV show (shared)
struct SeasonView: View {
    /// The TV show season
    let season: Video.Details.Season

    // MARK: Body of the View

    var body: some View {
        content
    }

    /// The body of this View
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            PartsView.DetailHeader(
                title: season.title
            )
            LazyVStack {
                ForEach(season.episodes) { episode in
                    EpisodeView.Item(episode: episode)
                        .padding(.horizontal, 20)
                }
            }
        }
        .id(season.season)
#endif

#if os(tvOS)
        HStack {
            /// Display the season cover
            KodiArt.Poster(item: season)
                .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                .cornerRadius(KomodioApp.cornerRadius)
                .watchStatus(of: season)
            List {
                ForEach(season.episodes) { episode in
                    EpisodeView.Item(episode: episode)
                }
            }
        }
        .focusSection()
#endif

#if os(iOS)
        HStack(alignment: .top) {
            /// Display the season cover
            KodiArt.Poster(item: season)
                .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                .cornerRadius(KomodioApp.cornerRadius)
                .watchStatus(of: season)
            LazyVStack {
                ForEach(season.episodes) { episode in
                    EpisodeView.Item(episode: episode)
                }
            }
        }
        .padding(.horizontal)
#endif
    }
}
