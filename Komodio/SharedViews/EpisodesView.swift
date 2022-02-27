//
//  EpisodesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 27/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI


/// A View for Episode items
struct EpisodesView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The TV show item in the library
    let tvshow: KodiItem
    /// The seasons of this TV show
    @State var seasons: [Int] = []
    /// The Episode items to show in this view
    @State var episodes: [KodiItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ItemsView.Description(description: tvshow.description)
            ForEach(seasons, id: \.self) { season in
                VStack {
                    Text(season == 0 ? "Specials" : "Season \(season)")
                        .font(.title3)
                        .padding(.top)
                    HStack(alignment: .top) {
                        ArtView.PosterList(poster: episodes.filter { $0.season == season }.first?.poster ?? "")
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
            print("EpisodesView task!")
            appState.filter.title = tvshow.title
            appState.filter.subtitle = "TV shows"
            /// Filter the episodes
            getEpisodes()
        }
        .iOS { $0.navigationTitle("Movies") }
        
    }
    /// Get the episodes from the Kodi database
    private func getEpisodes() {
        let filter = KodiFilter(media: .episode, tvshowID: tvshow.tvshowID)
        episodes = kodi.library.filter(filter)
        /// Group by seasons; specials (season 0) as last
        seasons = episodes.map { $0.season }
        .removingDuplicates()
        .sorted { ($0 == 0 ? Int.max: $0) < ($1 == 0 ? Int.max : $1) }
    }
}

extension EpisodesView {
    
    /// A View to link an episode to the Details View
    struct Link: View {
        
        /// The AppState model
        @EnvironmentObject var appState: AppState
        
        @Binding var item: KodiItem
        var body: some View {
            
            StackNavLink(path: "/TV shows/Episodes/Details/\(item.id)",
                         filter: appState.filter,
                         destination: DetailsView(item: item.binding())
            ) {
                Item(item: $item)
            }
            
            .buttonStyle(ButtonStyles.KodiItem(item: item))
            .tvOS { $0.frame(width: 1000) }
            .contextMenu {
                Button(action: {
                    item.toggleWatchedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
    
    /// A View for an episode item
    struct Item: View {
        /// The Episode item from the library
        @Binding var item: KodiItem
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
                    item.toggleWatchedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
}

