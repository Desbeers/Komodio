//
//  SeasonView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension SeasonView {

    // MARK: Season Details

    /// SwiftUI View for season details
    struct Details: View {
        /// The TV show season
        let season: Video.Details.Season

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: true,
                title: KomodioApp.platform == .macOS ? season.title : nil
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            ScrollView {
                LazyVStack {
                    ForEach(season.episodes) { episode in
                        EpisodeView.Item(episode: episode)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}
