//
//  ContentView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Content View

/// SwiftUI View for the main content (shared)
struct ContentView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        Group {
            switch scene.sidebarSelection {
            case .start:
                StartView()
            case .movies:
                MoviesView()
            case .unwatchedMovies:
                MoviesView(filter: .unwatched)
#if os(tvOS)
            case .playlists:
                PlaylistsView()
#endif
            case .tvshows:
                TVShowsView()
            case .seasons(let tvshow):
                TVShowsView(selectedTVShow: tvshow)
            case .unwachedEpisodes:
                UpNextView()
            case .musicVideos:
                ArtistsView()
            case .moviesPlaylist(let file):
                MoviesView(filter: .playlist(file: file))
            case .favourites:
                FavouritesView()
            case .search:
                SearchView()
            case .kodiSettings:
                KodiSettingsView()
            case .hostItemSettings(let host):
                HostItemView(host: host)
            default:
                Text("Not implemented")
            }
        }
        .navigationDestinations()
        .animation(.default, value: scene.navigationStackPath)
    }
}
