//
//  ContentView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
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
