//
//  TVShowView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension TVShowView {

    // MARK: TV show Details

    /// SwiftUI `View` for details of a `TV show`
    struct Details: View {
        /// The `TV show` to show
        let tvshow: Video.Details.TVShow

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? false : true,
                title: KomodioApp.platform == .macOS ? tvshow.title : nil
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            VStack {
                KodiArt.Fanart(item: tvshow)
                    .fanartStyle(item: tvshow)
#if os(macOS) || os(tvOS)
                Buttons.PlayedState(item: tvshow)
                    .padding()
                    .buttonStyle(.playButton)
#endif
                VStack(alignment: .leading) {
                    PartsView.TextMore(item: tvshow)
                        .backport.focusSection()
                    tvshowDetails
                }
            }
#if os(iOS)
            .toolbar {
                Buttons.PlayedState(item: tvshow)
                    .labelStyle(.titleAndIcon)
            }
#endif
        }

        // MARK: TV show details

        /// The details of the TV show
        var tvshowDetails: some View {
            VStack(alignment: .leading) {
                Label(info, systemImage: "info.circle.fill")
                Label(
                    "\(tvshow.season) \(tvshow.season == 1 ? " season" : "seasons"), \(tvshow.episode) episodes",
                    systemImage: "display"
                )
                Label(watchedLabel, systemImage: "eye")
            }
            .labelStyle(.detailLabel)
            .padding(.vertical)
        }

        /// Info about the TV show
        var info: String {
            let details = tvshow.studio + tvshow.genre + [tvshow.year.description]
            return details.joined(separator: " ∙ ")
        }

        /// Watched label
        var watchedLabel: String {
            if tvshow.watchedEpisodes == 0 {
                return "No episodes watched"
            } else if tvshow.watchedEpisodes == tvshow.episode {
                return "All episodes watched"
            } else {
                return "\(tvshow.watchedEpisodes) episodes watched"
            }
        }
    }
}
