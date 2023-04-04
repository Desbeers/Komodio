//
//  ContentView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Content View

/// SwiftUI View for the main content (tvOS)
struct ContentView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch scene.sidebarSelection {
            case .start:
                StartView()
            case .movies:
                MoviesView()
            case .unwatchedMovies:
                MoviesView(filter: .unwatched)
            case .playlists:
                PlaylistsView()
            case .tvshows:
                TVShowsView()
            case .unwachedEpisodes:
                UpNextView()
            case .musicVideos:
                ArtistsView()
            case .favourites:
                FavouritesView()
            case .search:
                SearchView()
            case .kodiSettings:
                KodiSettingsView()
            default:
                /// This should not happen
                Text("Not implemented")
            }
        }
        .animation(.default, value: scene.sidebarSelection)
        .setSiriExit()
    }
}
