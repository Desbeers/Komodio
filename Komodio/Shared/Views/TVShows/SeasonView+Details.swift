//
//  SeasonView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension SeasonView {

    // MARK: Season Details

    /// SwiftUI `View` with all `Episodes` of a selected `Season`
    struct Details: View {
        /// The TV show season
        let season: Video.Details.Season

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: season.id,
                title: KomodioApp.platform == .macOS ? season.title : nil
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            LazyVStack {
                ForEach(season.episodes) { episode in
                    ListItem(episode: episode)
                        .padding(.bottom)
                }
            }
        }
    }
}
