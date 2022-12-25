//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 400
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the View
    var body: some View {
        switch scene.contentSelection {
        case .start:
            VStack {
                Text(AppState.shared.host?.description ?? "No host selected")
                    .font(.system(size: 30))
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
