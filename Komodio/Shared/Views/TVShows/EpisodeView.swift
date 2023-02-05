//
//  EpisodeView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single Episode (shared)
enum EpisodeView {
    // Just a Namespace
}

extension EpisodeView {

    /// SwiftUI View for an Episode item
    struct Item: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            VStack(alignment: .leading) {
                Text(episode.title)
                    .font(.largeTitle)
                Text("Episode \(episode.episode)")
                Divider()
                HStack(alignment: .top, spacing: 0) {
                    KodiArt.Fanart(item: episode)
                        .watchStatus(of: episode)
                        .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                        .padding(4)
                        .background(.thickMaterial)
                        .cornerRadius(KomodioApp.thumbSize.width / 35)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        PartsView.TextMore(item: episode)
                            .frame(height: KomodioApp.thumbSize.height)
                        Buttons.Player(item: episode)
                    }
                }
                .detailsFontStyle()
            }
            .padding()
#endif

#if os(tvOS)
            VStack(alignment: .leading) {
                Text(episode.title)
                    .font(.title3)
                Text("Episode \(episode.episode)")
                    .font(.caption)
                Rectangle().fill(.secondary).frame(height: 1)
                HStack(alignment: .top, spacing: 0) {
                    KodiArt.Fanart(item: episode)
                        .watchStatus(of: episode)
                        .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(KomodioApp.thumbSize.width / 35)
                        .padding(.trailing)
                    PartsView.TextMore(item: episode)
                        .frame(height: KomodioApp.thumbSize.height)
                }
                .focusSection()
                Buttons.Player(item: episode)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focusSection()
            }
#endif

        }
    }
}
