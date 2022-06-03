//
//  HomeView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// The Home View for Komodio
struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi items to show in this View
    @State var items = HomeItems()
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The View
    var body: some View {
        ScrollView {
            // MARK: Unwatched movies
            Text(selectedItem?.media == .movie ? selectedItem!.title : "Unwatched Movies")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach($items.movies) { $movie in
                        NavigationLink(destination: DetailsView(item: $movie)) {
                            ArtView.Poster(item: movie)
                        }
                        .buttonStyle(.card)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .focused($selectedItem, equals: movie)
                        .contextMenu {
                            PartsView.WatchedToggle(item: $movie)
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            if selectedItem?.media == .movie {
                Text(selectedItem!.description)
                    .lineLimit(2)
                    .padding(.bottom)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            // MARK: Random music videos
            Text(selectedItem?.media == .musicVideo ? selectedItem!.title : "Random Music Videos")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach($items.musicvideos) { $movie in
                        NavigationLink(destination: DetailsView(item: $movie)) {
                            ArtView.Poster(item: movie)
                        }
                        .buttonStyle(.card)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .focused($selectedItem, equals: movie)
                    }
                }
                .padding(.horizontal, 40)
            }
            // MARK: New TV episodes
            Text(selectedItem?.media == .episode ? "\(selectedItem!.showTitle)" : "New TV show episodes")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach($items.episodes) { $movie in
                        NavigationLink(destination: DetailsView(item: $movie)) {
                            VStack {
                                ArtView.Poster(item: movie)
                                Text(movie.title)
                                    .font(.caption2)
                            }
                        }
                        .buttonStyle(.card)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .focused($selectedItem, equals: movie)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .task {
            items = getHomeItems()
        }
        .modifier(ViewModifierSelection(selectedItem: selectedItem))
        .animation(.default, value: selectedItem)
        .ignoresSafeArea(.all, edges: .horizontal)
    }
}

extension HomeView {
    
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
                            .filter { $0.media == .episode && $0.playcount == 0 && $0.season != 0 }
                            .sorted { $0.dateAdded > $1.dateAdded }
                            .unique { $0.tvshowID }
                            .prefix(10))
        )
        
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
