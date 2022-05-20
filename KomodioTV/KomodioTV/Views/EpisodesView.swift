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
    /// Show details
    @State var showDetail: Bool = false
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
            //PartsView.Header2(item: tvshow)
            
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
//            Button(action: {
//                showDetail.toggle()
//            }, label: {
//                Text(tvshow.description)
//                    .lineLimit(2)
//                    .padding()
//                    .frame(width: UIScreen.main.bounds.width - 160)
//            })
//            //.focused($selectedItem, equals: artist)
//            .buttonStyle(.card)
        }
        .background(ArtView.SelectionBackground(item: tvshow))
        .fullScreenCover(isPresented: $showDetail) {
            Text(tvshow.description)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
        }
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
            //ScrollView(.vertical, showsIndicators: false) {
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
                            //.shadow(radius: 20)
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
                            .focused($selectedItem, equals: episode)
                            //.zIndex(tvshow == selectedItem ? 2 : 1)
                        }
                    }
                    .padding(.horizontal, 100)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 300)
            .task {
                episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID)).filter { $0.season == season}
                //seasons = episodes.unique { $0.season }.map { $0.season }
            }
        }
    }
}

