//
//  EpisodesView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 25/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct EpisodesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The TV show item in the library
    let tvshow: MediaItem
    /// The Episode items to show in this view
    @State private var episodes: [MediaItem] = []
    /// The Season items to show in this view
    @State private var seasons: [Int] = []
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The selected tab
    @State private var selectedTab: Int = 1
    /// The subtitle for this View
    var subtitle: String? {
        if let subtitle = selectedItem {
            return subtitle.season == 0 ? "Specials" : "Season \(subtitle.season)"
        }
        return nil
    }
    /// The View
    var body: some View {
        VStack {
            /// Header
            PartsView.Header(title: tvshow.title, subtitle: tvshow.subtitle)
            Text(tvshow.description)
                .padding(.top)
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
            } else {
                Season(tvshow: tvshow, season: 1)
            }
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack(spacing: 0) {
//                    ForEach($episodes) { $episode in
//                        NavigationLink(destination: DetailsView(item: $episode)) {
//                            VStack {
//                                ArtView.Poster(item: episode)
//                                Text(episode.title)
//                            }
//                            .watchStatus(of: $episode)
//                        }
//                        .buttonStyle(.card)
//                        .padding()
//                        .focused($selectedItem, equals: episode)
//                        .zIndex(tvshow == selectedItem ? 2 : 1)
//                    }
//                }
//            }
        }
//        .onChange(of: selectedItem) { item in
//            appState.selection = item
//        }
        .background(ArtView.SelectionBackground(item: tvshow))
        .task {
            episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
            seasons = episodes.unique { $0.season }.map { $0.season }
        }
    }
}

extension EpisodesView {
    struct Season: View {
        let tvshow: MediaItem
        let season: Int
        /// The Episode items to show in this view
        @State private var episodes: [MediaItem] = []
        /// The focused item
        @FocusState var selectedItem: MediaItem?
        var body: some View {
            //ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    if let season = episodes.first {
                        AsyncImage(url: URL(string: season.poster)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(height: 400)
                        .padding(6)
                        .background(.secondary)
                        .cornerRadius(10)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 0) {
                    ForEach($episodes) { $episode in
                        NavigationLink(destination: DetailsView(item: $episode)) {
                            VStack {
                                ArtView.Poster(item: episode)
                                Text(episode.title)
                                    .font(.caption2)
                            }
                            .watchStatus(of: $episode)
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: episode)
                        //.zIndex(tvshow == selectedItem ? 2 : 1)
                    }
                        }
                        .padding(.leading)
                }
            }
            .task {
                episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID)).filter { $0.season == season}
                //seasons = episodes.unique { $0.season }.map { $0.season }
            }
        }
    }
}

