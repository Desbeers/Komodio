//
//  Episode+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension EpisodeView {

    // MARK: Up Next Details

    /// SwiftUI View for details of an `Episode`
    struct Details: View {
        /// The `Episode` to show
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? false : true,
                part: KomodioApp.platform == .macOS ? false : true,
                title: episode.showTitle,
                subtitle: "Season \(episode.season), episode \(episode.episode)"
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            VStack {
                KodiArt.Fanart(item: episode)
                    .fanartStyle(item: episode, overlay: episode.title)
                Buttons.Player(item: episode)
                    .padding()
                if
                    !KodiConnector
                        .shared
                        .getKodiSetting(id: .videolibraryShowuUwatchedPlots)
                        .list
                        .contains(1) && episode.playcount == 0
                {
                    Text("Plot is hidden for unwatched episodes...")
                } else {
                    PartsView.TextMore(item: episode)
                }
            }
            .padding(.bottom)
        }
    }
}
