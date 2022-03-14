//
//  HomeView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi items to show in this View
    @State var items = HomeItems()
    /// The View
    var body: some View {
        ItemsView.List() {
            Row(title: "Latest unwatched Movies", items: $items.movies)
            /// Move the first row below the tabs on tvOS
            //.tvOS { $0.padding(.top, 160) }
            Row(title: "Random Music Videos", items: $items.musicvideos)
            Row(title: "Latest TV show Episodes", items: $items.episodes)
            libraryReloadButton
            
        }
        .buttonStyle(ButtonStyles.HomeItem())
        .tvOS { $0.ignoresSafeArea(.all) }
        .task {
            items = getHomeItems()
        }
        .onChange(of: kodi.media) { _ in
            items = getHomeItems()
        }
    }
    /// A library 'reload' button
    var libraryReloadButton: some View {
        /// In a HStack to make it focusable in tvOS
        HStack {
            Button(action: {
                Task {
                    await kodi.reloadHost()
                }
            }, label: {
                Text("Reload Library")
                    .padding()
            })
                .padding(.all, 40)
        }
        .frame(maxWidth: .infinity)
#if os(tvOS)
        .focusSection()
        .buttonStyle(.card)
#endif
    }
    
    /// Get the home items
    private func getHomeItems() -> HomeItems {
        return HomeItems(movies: Array(kodi.media
                                        .filter { $0.media == .movie && $0.playcount == 0 }
                                        .sorted { $0.dateAdded > $1.dateAdded }
                                        .prefix(10)),
                         musicvideos: Array(kodi.media
                                                .filter { $0.media == .musicVideo && !$0.poster.isEmpty }
                                                .shuffled()
                                                .prefix(10)),
                         episodes: Array(kodi.media
                                            .filter { $0.media == .episode && $0.playcount == 0 }
                                            .sorted { $0.dateAdded > $1.dateAdded }
                                            .unique { $0.tvshowID }
                                            .prefix(10))
        )
        
    }
}

extension HomeView {
    
    /// A View with a row of Kodi items
    struct Row: View {
        /// The title of the row
        let title: String
        /// The Kodi items to show in this row
        @Binding var items: [MediaItem]
        /// The View
        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .padding(.horizontal)
                    .tvOS { $0.padding(.horizontal, 50) }
                    .macOS { $0.padding(.top) }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($items) { $item in
                            Item(item: $item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .tvOS { $0.padding(.horizontal, 50) }
                }
            }
        }
    }
    
    /// A Kodi item on the homescreen
    struct Item: View {
        /// The Kodi item
        @Binding var item: MediaItem
        /// The View
        var body: some View {
            VStack(spacing: 0) {
                RouterLink(item: .details(item: item)) {
                    VStack(spacing: 0) {
                        ArtView.PosterDetail(item: item)
                            .macOS { $0.frame(height: 300) }
                            .tvOS { $0.frame(height: 500) }
                            .iOS { $0.frame(height: 200) }
                            .watchStatus(of: $item)
                        if item.media == .episode {
                            Text(item.title)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
    
    /// A struct to collect items for the HomeView
    struct HomeItems: Equatable {
        /// Movie items
        var movies: [MediaItem] = []
        /// Music Video items
        var musicvideos: [MediaItem] = []
        /// Episode items
        var episodes: [MediaItem] = []
    }
}
