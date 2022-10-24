//
//  DetailsView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct DetailsView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    var body: some View {
        VStack {
            switch scene.selection {
            case .movies:
                if scene.selectedMovieSet != nil {
                    MovieSetView.Details()
                        .id(scene.selectedSeason)
                } else {
                    MoviesView.Details()
                }
            case .tvshows:
                if scene.selectedSeason != nil {
                    SeasonView()
                        .id(scene.selectedSeason)
                } else {
                    TVShowsView.Details()
                }
            default:
                Text("Not implemented")
            }
        }
    }
}
