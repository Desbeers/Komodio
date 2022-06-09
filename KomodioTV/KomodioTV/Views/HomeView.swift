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
    private var items: HomeItems {
        HomeItems(movies: Array(kodi.media
                                .filter { $0.media == .movie && $0.playcount == 0 }
                                .sorted { $0.dateAdded > $1.dateAdded }
                                .prefix(10)),
                  episodes: Array(kodi.media
                            .filter { $0.media == .episode && $0.playcount == 0 && $0.season != 0 }
                            .sorted { $0.dateAdded > $1.dateAdded }
                            .unique { $0.tvshowID }
                            .prefix(10))
        )
    }
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The body of this View
    var body: some View {
        ScrollView {
            // MARK: Unwatched movies
            Text(selectedItem?.media == .movie ? selectedItem!.title : "Unwatched Movies")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items.movies) { movie in
                        NavigationLink(destination: DetailsView(item: movie)) {
                            ArtView.Poster(item: movie)
                                .watchStatus(of: movie)
                        }
                        .buttonStyle(.card)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .focused($selectedItem, equals: movie)
                        .contextMenu(for: movie)
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
            // MARK: New TV episodes
            Text(selectedItem?.media == .episode ? "\(selectedItem!.showTitle)" : "New TV show episodes")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items.episodes) { episode in
                        NavigationLink(destination: DetailsView(item: episode)) {
                            VStack {
                                ArtView.Poster(item: episode)
                                Text(episode.title)
                                    .font(.caption2)
                            }
                            .watchStatus(of: episode)
                        }
                        .buttonStyle(.card)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80)
                        .focused($selectedItem, equals: episode)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .setSelection(of: selectedItem)
        .animation(.default, value: selectedItem)
        .ignoresSafeArea(.all, edges: .horizontal)
    }
}

extension HomeView {

    /// A struct with MediaItems  for the HomeView
    struct HomeItems: Equatable {
        /// Movie items
        var movies: [MediaItem] = []
        /// Music Video items
        var musicvideos: [MediaItem] = []
        /// Episode items
        var episodes: [MediaItem] = []
    }
}
