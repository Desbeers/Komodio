//
//  EpisodesView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 25/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for episodes of a TV show
struct EpisodesView: View {
    /// The selected TV show for this View
    let tvshow: MediaItem
    /// The episode items to show in this view
    @State private var episodes: [MediaItem] = []
    /// The seasons to show in this view
    @State private var seasons: [Int] = []
    /// The selected season tab
    @State private var selectedTab: Int = 1
    /// The View
    var body: some View {
        VStack {
            /// Show seasons on page tabs if we have more than one season
            /// - Note: Shown in 'page' style because SwiftUI can only show 7 tabs when using the 'normal' style
            ///         and there might be more seasons
            if seasons.count > 1 {
                TabView(selection: $selectedTab) {
                    ForEach(seasons, id: \.self) {season in
                        Season(tvshow: tvshow, season: season)
                            .tabItem {
                                Text(season == 0 ? "Specials" : "Season \(season)")
                            }
                            .tag(season)
                    }
                }
                .tabViewStyle(.page)
            } else {
                Season(tvshow: tvshow, season: 1)
            }
        }
        .background(ArtView.SelectionBackground(item: tvshow))
        .task {
            episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
            seasons = episodes.unique { $0.season }.map { $0.season }
        }
    }
}

extension EpisodesView {
    struct Season: View {
        /// The TV show
        let tvshow: MediaItem
        /// The season number
        let season: Int
        /// The Episode items to show in this view
        @State private var episodes: [MediaItem] = []
        /// The View
        var body: some View {
            HStack(spacing: 0) {
                if let season = episodes.first {
                    VStack {
                        Text(tvshow.title)
                            .font(.title3)
                        Text(season.season == 0 ? "Specials" : "Season \(season.season)")
                        AsyncImage(url: URL(string: season.poster)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 400, height: 600)
                        .padding(6)
                        .background(.secondary)
                        
                        .cornerRadius(10)
                    }
                    .padding(.trailing, 100)
                }
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach($episodes) { $episode in
                            NavigationLink(destination: DetailsView(item: $episode)) {
                                HStack(spacing: 0) {
                                    ArtView.Poster(item: episode)
                                        .padding(.trailing)
                                    VStack(alignment: .leading) {
                                        Text(episode.title)
                                        Text(episode.description)
                                            .font(.caption2)
                                            .lineLimit(5)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width - 900, alignment: .leading)
                                .watchStatus(of: $episode)
                            }
                            .buttonStyle(.card)
                            .padding()
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 100)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 300)
            .task {
                episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID)).filter { $0.season == season}
            }
        }
    }
}

