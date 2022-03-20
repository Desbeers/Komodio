//
//  HomeView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI

struct HomeView: View {
    /// The AppState model
    //@EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi items to show in this View
    @State var items = HomeItems()
    /// The View
    var body: some View {
        ItemsView.List() {
            VStack {
//#if !os(macOS)
                PartsView.MenuItems()
//#endif
                VStack {
                    Row(title: "Latest\nunwatched\nMovies", items: $items.movies)
                    Row(title: "Random\nMusic\nVideos", items: $items.musicvideos)
                    Row(title: "Latest\nTV show\nEpisodes", items: $items.episodes)
                    libraryReloadButton
                }
            }
        }
        .task {
            items = getHomeItems()
        }
        .onChange(of: kodi.media) { _ in
            items = getHomeItems()
        }
//        .onChange(of: appState.hoveredMediaItem) { item in
//            logger("Focus: \(item?.title)")
//        }
//        .animation(.default, value: appState.hoveredMediaItem)
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
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The title of the row
        let title: String
        /// The Kodi items to show in this row
        @Binding var items: [MediaItem]
        /// The View
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    Text(title)
                        .multilineTextAlignment(.trailing)
                        .macOS { $0.font(.title).frame(width: 120, alignment: .trailing) }
                        .tvOS { $0.font(.headline).frame(width: 200, alignment: .trailing) }
                        .iOS { $0.font(.title).frame(width: 180, alignment: .trailing) }
                        .padding(.horizontal)
                    Divider()
                    ForEach($items) { $item in
                        HStack {
                        Item(item: $item)
                                .zIndex(2)
                        if item == appState.hoveredMediaItem, !item.description.isEmpty {
                            
                                Text(item.description)
                                
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                                    .macOS { $0.frame(width: 300, height: 200) }
                                    .tvOS { $0.padding(.leading, -50).frame(width: 300, height: 500) }
                                    .iOS { $0.frame(width: 300, height: 300) }
                                    .transition(.opacity)
                                    .padding(.bottom)
                                    .zIndex(1)
                            }
                        }
                    }
                }
                .padding(.trailing, 50)
            }
            .animation(.default, value: appState.hoveredMediaItem)
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
                            .macOS { $0.frame(height: 200) }
                            .tvOS { $0.frame(height: 500) }
                            .iOS { $0.frame(height: 300) }
                            .watchStatus(of: $item)
                        if item.media == .episode {
                            Text(item.title)
                                .font(.caption)
                        }
                    }
                }
                .buttonStyle(ButtonStyles.HomeItem(item: item))
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
