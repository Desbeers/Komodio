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
        private let selectedTVshow: Video.Details.TVShow
        /// The KodiConnector model
        @Environment(KodiConnector.self) private var kodi
        /// The state values of the `TV show`
        @State private var tvshow: Video.Details.TVShow
        /// Init the `View`
        init(tvshow: Video.Details.TVShow) {
            self.selectedTVshow = tvshow
            self._tvshow = State(initialValue: tvshow)
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: StaticSetting.platform == .tvOS ? nil : tvshow.id,
                title: StaticSetting.platform == .macOS ? tvshow.title : nil
            ) {
                content
                    .animation(.default, value: tvshow)
                /// Update the state to the new selection
                    .task(id: selectedTVshow) {
                        tvshow = selectedTVshow
                    }
                /// Update the state from the library
                    .task(id: kodi.library.tvshows) {
                        if let update = update(tvshow: tvshow) {
                            tvshow = update
                        }
                    }
            }
        }

        /// Update a TVshow
        /// - Parameter tvshow: The current TV show
        /// - Returns: The updated TV show
        func update(tvshow: Video.Details.TVShow) -> Video.Details.TVShow? {
            if let update = kodi.library.tvshows.first(where: { $0.id == tvshow.id }), update != tvshow {
                return update
            }
            return nil
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
            .padding(.bottom)
#if os(iOS) || os(visionOS)
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
