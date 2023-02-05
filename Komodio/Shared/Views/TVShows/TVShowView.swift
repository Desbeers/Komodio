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

    // MARK: Private functions

    /// Update a TV show
    ///
    /// On `tvOS`, TV show details are shown in its own View so it needs to update itself when movie details are changed
    ///
    /// - Parameter tvshow: The TV show to update
    /// - Returns: If update is found, the updated Movie, else `nil`
    static private func updateTVshow(tvshow: Video.Details.TVShow) -> Video.Details.TVShow? {
        if let update = KodiConnector.shared.library.tvshows.first(where: {$0.id == tvshow.id}), update != tvshow {
            return update
        }
        return nil
    }
}

extension TVShowView {

    // MARK: TV show item

    /// SwiftUI View for a TV show item
    struct Item: View {
        /// The TV show
        let tvshow: Video.Details.TVShow

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
                KodiArt.Poster(item: tvshow)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: tvshow)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(tvshow.title)
                        .font(.headline)
                    Text(tvshow.genre.joined(separator: "∙"))
                    Text(tvshow.year.description)
                        .font(.caption)
                }
                /// Make the whole area clickable
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
#endif

            }
        }
    }
}

extension TVShowView {

    // MARK: TV show details

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
                ScrollView {
                    VStack {
                        Text(tvshow.title)
                            .font(.system(size: 40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        KodiArt.Fanart(item: tvshow)
                            .aspectRatio(contentMode: .fit)
                            .watchStatus(of: tvshow)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                            .padding(.bottom)
                        Buttons.PlayedState(item: tvshow)
                            .padding(.bottom)
                            .labelStyle(.playLabel)
                            .buttonStyle(.playButton)
                        VStack(alignment: .leading) {
                            Text(tvshow.plot)
                            tvshowDetails
                        }
                    }
                    .detailsFontStyle()
                    .padding(40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
#endif

#if os(tvOS)
                HStack {
                    KodiArt.Poster(item: tvshow)
                        .watchStatus(of: tvshow)
                        .cornerRadius(10)
                    VStack {
                        Text(tvshow.title)
                            .font(.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(.bottom)
                        KodiArt.Fanart(item: tvshow)
                            .cornerRadius(10)
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
            .animation(.default, value: tvshow)
            .background(item: tvshow)
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
                Label("\(tvshow.season) \(tvshow.season == 1 ? " season" : "seasons"), \(tvshow.episode) episodes", systemImage: "display")
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
