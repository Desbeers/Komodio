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
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The selected TV show for this View
    let tvshow: Video.Details.TVShow
    /// The episode items to show in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The seasons to show in this view
    @State private var seasons: [Int] = []
    /// The selected season tab
    @State private var selectedTab: Int = -1
    /// The body of this View
    var body: some View {
        VStack {
            /// Show seasons on page tabs
            /// - Note: Shown in 'page' style because SwiftUI can only show 7 tabs when using the 'normal' style
            ///         and there might be more seasons
            if !seasons.isEmpty {
                TabView(selection: $selectedTab) {
                    TVshowInfo(tvshow: tvshow, selectedTab: $selectedTab)
                        .tag(-1)
                    ForEach(seasons, id: \.self) {season in
                        Season(tvshow: tvshow, episodes: episodes.filter { $0.season == season } )
                            .tag(season)
                    }
                }
                .tabViewStyle(.page)
            }
        }
        .task(id: kodi.library.episodes) {
            episodes = kodi.library.episodes
                .filter({$0.tvshowID == tvshow.tvshowID})
            seasons = episodes.unique { $0.season }.map { $0.season }.sorted{ ($0 == 0 ? Int.max : $0) < ($1 == 0 ? Int.max : $1) }
        }
    }
}

extension EpisodesView {
    
    struct TVshowInfo: View {
        /// The TV show
        let tvshow: Video.Details.TVShow
        /// The selected tab
        @Binding var selectedTab: Int
        /// The body of this View
        var body: some View {
            VStack {
                Text(tvshow.title)
                    .font(.title)
                HStack {
                    KodiArt.Poster(item: tvshow)
                        .frame(width: 400, height: 600)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(tvshow.plot)
                            .padding(.bottom)
                        Label("\(tvshow.season) \(tvshow.season == 1 ? " season" : "seasons"), \(tvshow.episode) episodes", systemImage: "display")
                            .padding(.bottom)
                        Label("\(tvshow.watchedEpisodes) episodes watched", systemImage: "eye")
                        //                        if tvshow.watchedEpisodes != tvshow.episode {
                        //                            Button(action: {
                        //                                if let episode = KodiConnector.shared.library.episodes.first(where: { $0.tvshowID == tvshow.tvshowID && $0.playcount == 0}) {
                        //                                    selectedTab = episode.season
                        //                                }
                        //                            }, label: {
                        //                                Text("Jump to first \(tvshow.watchedEpisodes != tvshow.episode ? " unwached" : "") episode")
                        //                            })
                        //                        }
                        Button(action: {
                            if tvshow.watchedEpisodes != tvshow.episode, let episode = KodiConnector.shared.library.episodes.first(where: { $0.tvshowID == tvshow.tvshowID && $0.playcount == 0}) {
                                selectedTab = episode.season
                            }
                        }, label: {
                            Text("Jump to first \(tvshow.watchedEpisodes != tvshow.episode ? " unwached" : "") episode")
                        })
                        Spacer()
                    }
                    .focusSection()
                }
            }
            //.focusable()
        }
    }
    
    /// A View with all episodes from a TV show season
    struct Season: View {
        /// The TV show
        let tvshow: Video.Details.TVShow
        /// The Episode items to show in this view
        let episodes: [Video.Details.Episode]
        
        @FocusState var selectedItem: Video.Details.Episode?
        
        
        /// The body of this View
        var body: some View {
            HStack(spacing: 0) {
                // MARK: Display the season cover
                if let season = episodes.first {
                    VStack {
                        Text(tvshow.title)
                            .font(.title3)
                        Text(season.season == 0 ? "Specials" : "Season \(season.season)")
                        KodiArt.Poster(item: season)
                            .frame(width: 400, height: 600)
                        //.padding(6)
                        //.background(.secondary)
                        
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 100)
                }
                // MARK: Diplay all episodes from the selected season
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(episodes) { episode in
                            Episode(episode: episode)
                                .buttonStyle(.card)
                                .padding()
                                .padding(.horizontal)
                            /// - Note: Context Menu must go after the Button Style or else it does not work...
                                .contextMenu(for: episode)
                                .focused($selectedItem, equals: episode)
                        }
                    }
                    .padding(.horizontal, 100)
                }
            }
            .task {
                print("SEASON TASK")
                selectedItem = episodes.first
            }
            .frame(width: UIScreen.main.bounds.width - 300)
        }
    }
    
    /// A View with one episode
    struct Episode: View {
        /// The Episode
        let episode: Video.Details.Episode
        @State private var isPresented = false
        var body: some View {
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                HStack(spacing: 0) {
                    KodiArt.Art(file: episode.thumbnail)
                    //MediaArt.Poster(item: episode)
                        .frame(width: 320, height: 180)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(episode.title)
                        Text(episode.plot)
                            .font(.caption2)
                            .lineLimit(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 900, alignment: .leading)
                .watchStatus(of: episode)
            })
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: episode)
            }
        }
    }
    
    
    struct Item: View {
        let episode: Video.Details.Episode
        @State private var isPresented = false
        var body: some View {
            
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                VStack {
                    KodiArt.Art(file: episode.thumbnail)
                        .frame(width: 400, height: 225)
                        .watchStatus(of: episode)
                    Text(episode.showTitle)
                        .font(.caption2)
                        .padding(.bottom, 8)
                }
            })
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: episode)
            }
        }
    }
    
}
