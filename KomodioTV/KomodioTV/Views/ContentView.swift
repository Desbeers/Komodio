//
//  ContentView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI

/// The Content View for Komodio
struct ContentView: View {
    /// The selected tab
    @State private var selectedTab: String = "home"
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag("home")
                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                    .tag("movies")
                TVShowsView()
                    .tabItem {
                        /// tvOS is acting weird if the image has no rendering mode
                        Label(title: {
                            Text("Shows")
                        }, icon: {
                            Image(systemName: "tv")
                                .renderingMode(.original)
                        })
                    }
                    .tag("shows")
                ArtistsView()
                    .tabItem {
                        Label("Music", systemImage: "music.quarternote.3")
                    }
                    .tag("music")
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag("search")
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag("settings")
            }
        }
    }
}
