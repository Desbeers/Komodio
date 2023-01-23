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

    /// SwiftUI View for Episode details in a list
    struct Details: View {
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
                        Text(episode.plot)
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
                    VStack(alignment: .leading) {
                        Text(episode.plot)
                            .lineLimit(7, reservesSpace: true)
                    }
                }
                Buttons.Player(item: episode)
            }
#endif

        }
    }
}

extension EpisodeView {

    /// SwiftUI View for details of a single Episode
    /// - Used in ``UpNextView``
    struct Item: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(episode.showTitle)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: episode)
                        .watchStatus(of: episode)
                        .overlay(alignment: .bottom) {
                            Text(episode.title)
                                    .font(.title2)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(.regularMaterial)
                        }
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                    Buttons.Player(item: episode)
                        .padding()
                    Text(episode.plot)
                }
                .detailsFontStyle()
                .padding(40)
            }
            .background(item: episode)
#endif

#if os(tvOS)
            VStack {
                Text(episode.showTitle)
                    .font(.title)
                KodiArt.Fanart(item: episode)
                    .watchStatus(of: episode)
                    .overlay(alignment: .bottom) {
                        Text(episode.title)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                    }
                    .cornerRadius(KomodioApp.thumbSize.width / 35)
                    .padding()
                Text(episode.plot)
                    Buttons.Player(item: episode)
            }
            .background(item: episode)
#endif

        }
    }
}
