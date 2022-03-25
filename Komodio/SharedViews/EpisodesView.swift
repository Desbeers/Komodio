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
    private let tvshow: MediaItem
    /// The Episode items to show in this view
    private let episodes: [MediaItem]
    /// Init the View
    init(tvshow: MediaItem) {
        self.tvshow = tvshow
        self.episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
    }
    /// The View
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                ForEach(episodes.indices, id: \.self) { episode in
                    if episode == 0 || (episode > 0 && episodes[episode - 1].season != episodes[episode].season) {
                        Text(episodes[episode].season == 0 ? "Specials" : "Season \(episodes[episode].season)")
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .macOS { $0.font(.title) }
                            .tvOS { $0.font(.title3) }
                    }
                    
                    Link(item: episodes[episode].binding())
                }
            }
            /// Make room for the details
            .macOS { $0.padding(.leading, 330) }
            .tvOS { $0.padding(.leading, 500) }
            if router.selectedMediaItem != nil {
                //ArtView.PosterList(poster: router.selectedMediaItem!.poster)
                ItemsView.Details(item: router.selectedMediaItem!)
            }
        }
        .task {
            logger("Episode task: \(episodes.count)")
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: episodes.first)
            }
        }
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
            .buttonStyle(ButtonStyles.MediaItem(item: item))
            .macOS { $0.padding(.horizontal, 40) }
            .tvOS { $0.padding(.horizontal, 80) }
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
            HStack {
                ArtView.Episode(item: item)
                    .macOS { $0.frame(height: 100) }
                    .tvOS { $0.frame(height: 200) }
                    .iOS { $0.frame(height: 200) }
                VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.details)
                    .font(.caption)
                Divider()
                Text(item.description)
                    .lineLimit(2)
                }
            }
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

