//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI

struct ContentView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    var body: some View {
        switch scene.sidebar {
        case .movies:
            MoviesView()
        case .tvshows:
            TVShowsView()
        default:
            Text("Not implemented")
        }
    }
}
