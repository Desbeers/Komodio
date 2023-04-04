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

    /// SwiftUI View for TV show details
    struct Details: View {
        /// The TV show
        @State var tvshow: Video.Details.TVShow
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Group {

#if os(macOS)
                DetailWrapper(title: tvshow.title) {
                    VStack {
                        KodiArt.Fanart(item: tvshow)
                            .fanartStyle(item: tvshow)
                        Buttons.PlayedState(item: tvshow)
                            .padding()
                            .labelStyle(.playLabel)
                            .buttonStyle(.playButton)
                        VStack(alignment: .leading) {
                            Text(tvshow.plot)
                            tvshowDetails
                        }
                    }
                    .detailsFontStyle()
                }
#endif

#if os(tvOS)
                HStack {
                    KodiArt.Poster(item: tvshow)
                        .frame(width: 400, height: 600)
                        .cornerRadius(10)
                        .watchStatus(of: tvshow)
                    VStack {
                        KodiArt.Fanart(item: tvshow)
                            .fanartStyle(item: tvshow)
                        PartsView.TextMore(item: tvshow)
                            .focusSection()
                        HStack {
                            tvshowDetails
                            Buttons.PlayedState(item: tvshow)
                                .labelStyle(.playLabel)
                                .buttonStyle(.card)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
#endif
            }
            .task(id: kodi.library.tvshows) {
                if let update = TVShowView.updateTVshow(tvshow: tvshow) {
                    tvshow = update
                }
            }
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
