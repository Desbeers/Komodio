//
//  HomeView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher

struct HomeView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi items to show in this View
    @State var items = HomeItems()
    
    @FocusState var selectedItem: MediaItem?
    
    /// The View
    var body: some View {
        ItemsView.List() {
            VStack {
                //#if !os(macOS)
                PartsView.MenuItems()
                Text(selectedItem != nil ? selectedItem!.title : "No selection")
                    .frame(maxWidth: .infinity, alignment: .leading)
                //#endif
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach($items.movies) { $movie in
                            Button(action: {
                            }, label: {
                                ArtView.Poster(item: movie)
                            })
                            .buttonStyle(.card)
                            .contextMenu {
                                    Button {
                                        print("Change country setting")
                                    } label: {
                                        Label("Choose Country", systemImage: "globe")
                                    }
                            }
                            .padding(40)
                            .focused($selectedItem, equals: movie)
                        }
                        //Row(title: "Latest\nunwatched\nMovies", items: $items.movies)
                        //Row(title: "Random\nMusic\nVideos", items: $items.musicvideos)
                        //Row(title: "Latest\nTV show\nEpisodes", items: $items.episodes)
                    }
                }
                .focusSection()
                if let item = selectedItem {
                    Text(item.description)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach($items.musicvideos) { $movie in
                            Button(action: {
                            }, label: {
                                ArtView.Poster(item: movie)
                            })
                            .buttonStyle(.card)
                            .focused($selectedItem, equals: movie)
                        }
                        //Row(title: "Latest\nunwatched\nMovies", items: $items.movies)
                        //Row(title: "Random\nMusic\nVideos", items: $items.musicvideos)
                        //Row(title: "Latest\nTV show\nEpisodes", items: $items.episodes)
                    }
                }
                .focusSection()
            }
        }
        .task {
            items = getHomeItems()
            /// Deselect any previous selected media item
            router.setSelectedMediaItem(item: nil)
        }
        .onChange(of: kodi.media) { _ in
            items = getHomeItems()
        }
//        .onChange(of: appState.hoveredMediaItem) { item in
//            logger("Focus: \(item?.title)")
//        }
//        .animation(.default, value: appState.hoveredMediaItem)
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
        /// The Roter model
        @EnvironmentObject var router: Router
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
                            if item == router.selectedMediaItem {
                                Group {
                                    switch item.media {
                                    case .episode:
                                        VStack {
                                            Text("Season \(item.season)")
                                            Text("Episode \(item.episode)")
                                                .font(.caption)
                                        }
                                    case .musicVideo:
                                        VStack {
                                            Text("\(item.title)")
                                            Text("\(item.subtitle)")
                                                .font(.caption)
                                        }
                                        //Text(item.subtitle)
                                    default:
                                        Text(item.description)
                                            .lineLimit(10)
                                            .frame(width: 300)
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(6)
                                
                                .tvOS { $0.padding(.leading, -50).padding(.trailing, -30) }
                                .zIndex(1)
                            }
                        }
                    }
                }
                .padding(.trailing, 50)
            }
            .animation(.default, value: router.selectedMediaItem)
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
                        ArtView.Poster(item: item)
//                            .macOS { $0.frame(height: 200) }
//                            .tvOS { $0.frame(height: 500) }
//                            .iOS { $0.frame(height: 300) }
                            .watchStatus(of: $item)
                        if item.media == .episode {
                            Text(item.subtitle)
                                .font(.caption)
                        }
                    }
                }
                .buttonStyle(ButtonStyles.MediaItem(item: item, doubleClick: true))
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
