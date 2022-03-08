//
//  EpisodesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 27/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

/// A View for Episode items
struct EpisodesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The TV show item in the library
    let tvshow: MediaItem
    /// The seasons of this TV show
    //@State var seasons: [Int] = []
    /// The Episode items to show in this view
    @State var episodes: [MediaItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ItemsView.Description(description: tvshow.description)
                .padding()
            /// More padding for tvOS
                .tvOS { $0.padding(.horizontal, 60)}
            ForEach(tvshow.seasons, id: \.self) { season in
                VStack {
                    Text(season == 0 ? "Specials" : "Season \(season)")
                        .font(.title3)
                        .padding(.top)
                    HStack(alignment: .top) {
                        ArtView.PosterEpisode(poster: episodes.filter { $0.season == season }.first?.poster ?? "")
                            .cornerRadius(6)
                            .padding()
                        VStack {
                            ForEach(episodes.filter { $0.season == season }) { episode in
                                Link(item: episode.binding())
                            }
                        }
                    }
                }
            }
        }
        .task {
            logger("EpisodesView task!")
            /// Filter the episodes
            let filter = MediaFilter(media: .episode, tvshowID: tvshow.tvshowID)
            episodes = kodi.media.filter(filter)
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

