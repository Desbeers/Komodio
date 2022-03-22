//
//  EpisodesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI

/// A View for Episode items
struct EpisodesView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The TV show item in the library
    let tvshow: MediaItem
    /// The Episode items to show in this view
    private var episodes: [MediaItem]
    
    init(tvshow: MediaItem) {
        self.tvshow = tvshow
        self.episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
    }
    
    /// The View
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                            ForEach(episodes) { episode in
                                Link(item: episode.binding())
                            }
            }
            /// Make room for the details
            .macOS { $0.padding(.leading, 330) }
            .tvOS { $0.padding(.leading, 550) }
            if router.selectedMediaItem != nil {
                //ArtView.PosterList(poster: router.selectedMediaItem!.poster)
                ItemsView.Details(item: router.selectedMediaItem!)
            }
            
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            logger("TV show task: \(episodes.count)")
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: episodes.first)
            }
        }
        
        
//        ItemsView.List() {
//
//            ForEach(episodes) { episode in
//                ItemsView.Item(item: episode.binding())
//            }
//
//            ForEach(seasons(episodes), id: \.self) { season in
//                VStack {
//                    Text(season == 0 ? "Specials" : "Season \(season)")
//                        .font(.title3)
//                        .padding(.top)
//                    HStack(alignment: .top) {
//                        ArtView.PosterEpisode(poster: episodes.filter { $0.season == season }.first?.poster ?? "")
//                            .cornerRadius(6)
//                            .padding()
//                        VStack {
//                            ForEach(episodes.filter { $0.season == season }) { episode in
//                                Link(item: episode.binding())
//                                    .id(episode.id)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .task {
//            /// Filter the episodes
//            //let filter = MediaFilter(media: .episode, tvshowID: tvshow.tvshowID)
//            //episodes = kodi.media.filter(filter)
//            //episodes = getEpisodes()
//            //dump(episodes)
//        }
//        .onChange(of: kodi.media) { _ in
//            //episodes = getEpisodes()
//        }
    }
    /// Get the episodes
    private func getEpisodes() -> [MediaItem] {
        return kodi.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
    }
    /// Order by seasons; specials as last
    private func seasons( _ episodes: [MediaItem]) -> [Int] {
        return episodes.map { $0.season }
        .removingDuplicates()
        .sorted { ($0 == 0 ? Int.max : $0) < ($1 == 0 ? Int.max : $1) }
    }
}

extension EpisodesView {
    
    /// A View to link an episode item to the Details View
    struct Link: View {
        /// The Kodi item we want to link
        @Binding var item: MediaItem
        /// The link
        var body: some View {
            RouterLink(item: .details(item: item)) {
                Item(item: $item)
            }
            .buttonStyle(ButtonStyles.HomeItem(item: item))
            .tvOS { $0.frame(width: 1000) }
            .contextMenu {
                Button(action: {
                    item.togglePlayedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
    
    /// A View for an episode item
    struct Item: View {
        /// The Episode item from the library
        @Binding var item: MediaItem
        /// The View
        var body: some View {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.details)
                    .font(.caption)
                Divider()
                Text(item.description)
                    .lineLimit(2)
            }
            .tvOS { $0.frame(width: 1000) }
            .padding()
            .watchStatus(of: $item)
            .contextMenu {
                Button(action: {
                    item.togglePlayedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
}

