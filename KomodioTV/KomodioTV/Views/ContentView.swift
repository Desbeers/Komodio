//
//  ContentView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                TVshowsView()
                    .tabItem {
                        Label("Shows", systemImage: "tv")
                    }
                MusicVideosView()
                    .tabItem {
                        Label("Music", systemImage: "music.quarternote.3")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
