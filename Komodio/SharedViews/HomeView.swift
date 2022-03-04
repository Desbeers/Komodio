//
//  HomeView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct HomeView: View {
    
    /// The AppState model
    @EnvironmentObject var appState: AppState

    
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    /// The Router model
    @EnvironmentObject var router: Router
    
    /// Library loading state
    @State var libraryLoaded: Bool = false
    var body: some View {
        VStack {
            if libraryLoaded {
                Items()
            } else {
                LoadingView()
            }
        }
        .task {
            print("HomeView Task!")
            //navigator.clear()
            appState.filter.title = "Home"
            appState.filter.subtitle = nil
            appState.filter.fanart = nil
            appState.filter.media = .none
            libraryLoaded = kodi.library.isEmpty ? false : true
        }
        .onChange(of: kodi.library) { newLibrary in
            print("Library changed")
            libraryLoaded = newLibrary.isEmpty ? false : true
        }
    }
}

extension HomeView {
    struct Items: View {
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
                print("HomeView.Items task!")
                items = getHomeItems(library: kodi.library)
            }
        }
        /// A library 'reload' button
        var libraryReloadButton: some View {
            /// In a HStack to make it focusable in tvOS
            HStack {
                /// On macOS, the reload button is in the toolbar, so no need here
                Button(action: {
                    kodi.reloadHost()
                }, label: {
                    Text("Reload Library")
                })
                    .buttonStyle(.bordered)
                    .padding(.all, 40)
            }
            .frame(maxWidth: .infinity)
    #if os(tvOS)
            .focusSection()
    #endif
        }
        
        /// Get the home items
        private func getHomeItems(library: [KodiItem]) -> HomeItems {
            return HomeItems(movies: Array(library
                                                .filter { $0.media == .movie && $0.playcount == 0 }
                                                .sorted { $0.dateAdded > $1.dateAdded }
                                                .prefix(10)),
                              musicvideos: Array(library
                                                    .filter { $0.media == .musicvideo && !$0.poster.isEmpty }
                                                    .shuffled()
                                                    .prefix(10)),
                              episodes: Array(library
                                                .filter { $0.media == .episode && $0.playcount == 0 }
                                                .sorted { $0.dateAdded > $1.dateAdded }
                                                .unique { $0.tvshowID }
                                                .prefix(10))
            )
            
        }
    }
}

extension HomeView {

    /// A View with a row of Kodi items
    struct Row: View {
        /// The title of the row
        let title: String
        /// The Kodi items to show in this row
        @Binding var items: [KodiItem]
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
        @Binding var item: KodiItem
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
        var movies: [KodiItem] = []
        /// Music Video items
        var musicvideos: [KodiItem] = []
        /// Episode items
        var episodes: [KodiItem] = []
    }
}
