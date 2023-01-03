//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 400
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the View
    var body: some View {
        Group {
            switch scene.contentSelection {
            case .start:
                VStack {
                    Text(appState.host?.description ?? kodi.state.rawValue)
                        .font(.largeTitle)
                        .padding()
                    StartView()
                }
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
}
