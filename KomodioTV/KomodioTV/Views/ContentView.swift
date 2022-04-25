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
                        Label("TV shows", systemImage: "tv")
                    }
                MusicVideosView()
                    .tabItem {
                        Label("Music Videos", systemImage: "music.quarternote.3")
                    }
            }
        }
    }
}
