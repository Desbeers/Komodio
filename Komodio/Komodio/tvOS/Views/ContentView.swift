//
//  ContentView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 15/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the View
    var body: some View {
        switch scene.contentSelection {
        case .start:
            StartView()
            .setSafeAreas()
        case .movies:
            MoviesView()
        case .unwatchedMovies:
            MoviesView(filter: .unwatched)
        case .tvshows:
            TVShowsView()
        case .seasons(let tvshow):
            TVShowsView(selectedTVShow: tvshow)
        case .unwachedEpisodes:
            UpNextView()
        case .musicVideos:
            ArtistsView()
        case .search:
            SearchView()
                .padding(.horizontal, KomodioApp.sidebarCollapsedWidth)
                .setSafeAreas()
        case .kodiSettings:
            KodiSettingsView()
                .setSafeAreas()
        default:
            Text("Not implemented")
        }
    }
}
