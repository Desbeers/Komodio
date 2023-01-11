//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main content (macOS)
struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 400
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The AppState model
    @EnvironmentObject private var appState: AppState
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
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
        case .search:
            SearchView()
        case .kodiSettings:
            KodiSettingsView()
        default:
            Text("Not implemented")
        }
    }
}
