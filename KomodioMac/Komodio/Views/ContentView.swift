//
//  ContentView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI

struct ContentView: View {
    /// The ContentView Column Width
    /// - Note: Used for the width as well the animation in the Content View
    static let columnWidth: Double = 400
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the view
    var body: some View {
        switch scene.sidebar {
        case .movies:
            MoviesView()
        case .tvshows:
            TVShowsView()
        case .musicVideos:
            ArtistsView()
        default:
            Text("Not implemented")
        }
    }
}
