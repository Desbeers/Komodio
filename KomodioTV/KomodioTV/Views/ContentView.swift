//
//  ContentView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Content' SwiftUI View
struct ContentView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The body of this View
    var body: some View {
        NavigationStack {
            TabView(selection: $appState.selectedTab) {
                StartView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(AppState.Tabs.home)
                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                    .tag(AppState.Tabs.movies)
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
                    .tag(AppState.Tabs.shows)
                ArtistsView()
                    .tabItem {
                        Label("Music", systemImage: "music.quarternote.3")
                    }
                    .tag(AppState.Tabs.music)
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(AppState.Tabs.search)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(AppState.Tabs.settings)
            }
        }
    }
}
