//
//  TVShowView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single TV show (shared)
enum TVShowView {
    // Just a Namespace
}

extension TVShowView {

    // MARK: Details of a TV show

    /// SwiftUI View for TV show details
    struct Details: View {
        /// The TV show
        let tvshow: Video.Details.TVShow
        /// Info about the TV show
        var info: String {
            let details = tvshow.studio + tvshow.genre + [tvshow.year.description]
            return details.joined(separator: " ∙ ")
        }

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(tvshow.title)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: tvshow)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        Text(tvshow.plot)
                        tvshowDetails
                    }
                }
                .detailsFontStyle()
                .padding(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(item: tvshow)
#endif

#if os(tvOS)
            HStack {
                KodiArt.Poster(item: tvshow)
                    .cornerRadius(10)
                VStack {
                    Text(tvshow.title)
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.bottom)
                    KodiArt.Fanart(item: tvshow)
                        .cornerRadius(10)
                    Text(tvshow.plot)
                    tvshowDetails
                }
            }
            .background(item: tvshow)
#endif

        }

        /// The details of the TV show
        var tvshowDetails: some View {
            VStack(alignment: .leading) {
                Label(info, systemImage: "info.circle.fill")
                Label("\(tvshow.season) \(tvshow.season == 1 ? " season" : "seasons"), \(tvshow.episode) episodes", systemImage: "display")
                Label(watchedLabel, systemImage: "eye")
            }
            .labelStyle(Styles.DetailLabel())
            .padding(.vertical)
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
