//
//  ContentView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 15/12/2022.
//

import SwiftUI

struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 240
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the view
    var body: some View {
        switch scene.contentSelection {
        case .start:
            StartView()
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
//        case .search:
//            SearchView()
//        case .kodiSettings:
//            KodiSettings()
        default:
            Text("Not implemented")
        }
    }
}
