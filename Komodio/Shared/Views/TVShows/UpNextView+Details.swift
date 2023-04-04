//
//  UpNextView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension UpNextView {

    // MARK: Up Next Details

    /// SwiftUI View for Episode details in a  ``UpNextView`` list
    struct Details: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
#if os(macOS)
            DetailWrapper(
                title: episode.showTitle,
                subtitle: "Season \(episode.season), episode \(episode.episode)"
            ) {
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
                .detailsFontStyle()
            }
#endif

#if os(tvOS)
            VStack {
                Text("\(episode.showTitle): \(episode.title)")
                    .font(.title2)
                Text("Season \(episode.season), episode \(episode.episode)")
                Divider()
                HStack {
                    KodiArt.Fanart(item: episode)
                        .fanartStyle(item: episode)
                        .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                    VStack {
                        if
                            !KodiConnector
                                .shared
                                .getKodiSetting(id: .videolibraryShowuUwatchedPlots)
                                .list
                                .contains(1) && episode.playcount == 0 {
                            Text("Plot is hidden for unwatched episodes...")
                        } else {
                            PartsView.TextMore(item: episode)
                                .frame(height: KomodioApp.thumbSize.height)
                        }
                    }
                }
                Buttons.Player(item: episode)
                /// Make sure tvOS can get the focus
                    .frame(maxWidth: .infinity)
                    .focusSection()
                    .padding()
            }
            .frame(maxWidth: .infinity)
#endif
        }
    }
}
