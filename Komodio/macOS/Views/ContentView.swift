//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Content View

/// SwiftUI View for the main content (macOS)
struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 400
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        NavigationStack(path: $scene.navigationStackPath) {
            Group {
                switch scene.sidebarSelection {
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
            .navigationDestination(for: Video.Details.MovieSet.self) { movieSet in
                MovieSetView(movieSet: movieSet)
            }
            .navigationDestination(for: Video.Details.TVShow.self) { tvshow in
                SeasonsView(tvshow: tvshow)
            }
            .navigationDestination(for: Audio.Details.Artist.self) { artist in
                MusicVideosView(artist: artist)
            }
        }
    }
}
