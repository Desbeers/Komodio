//
//  EpisodeView+Item.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension EpisodeView {

    // MARK: Episode Item

    /// SwiftUI View for an Episode item
    struct Item: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack(alignment: .leading) {
                Text(episode.title)
                    .font(.title3)
                Text("Episode \(episode.episode)")
                    .font(.caption)
                Rectangle().fill(.secondary).frame(height: 1)
                HStack(alignment: .top, spacing: 0) {
                    KodiArt.Fanart(item: episode)
                        .fanartStyle(item: episode)
                        .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                        .padding(.trailing)
                    if !KodiConnector.shared.getKodiSetting(id: .videolibraryShowuUwatchedPlots)
                        .list.contains(1) && episode.playcount == 0 {
                        Text("Plot is hidden for unwatched episodes...")
                    } else {
                        PartsView.TextMore(item: episode)
                            .frame(height: KomodioApp.thumbSize.height)
                    }
                }
                .focusSection()
                Buttons.Player(item: episode, fadeStateButton: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focusSection()
            }
            .detailsFontStyle()
        }
    }
}
