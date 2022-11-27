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
            switch scene.selection.route {
            case .movies:
                if let movie = scene.selection.movie {
                    MoviesView.Details(movie: movie)
                } else {
                    Default(selection: .movies)
                }
            case .movieSet:
                if let movie = scene.selection.movie {
                    MoviesView.Details(movie: movie)
                } else if let movieSet = scene.selection.movieSet {
                    MovieSetView.Details(movieSet: movieSet)
                } else {
                    Default(selection: .movieSet)
                }
            case .tvshows:
                if let tvshow = scene.selection.tvshow {
                    TVShowsView.Details(tvshow: tvshow)
                } else {
                    Default(selection: .tvshows)
                }
            case .season:
                if let tvshow = scene.selection.tvshow, let season = scene.selection.season {
                    SeasonsView.Details(tvshow: tvshow, season: season)
                        .id(season)
                } else if let tvshow = scene.selection.tvshow {
                    TVShowsView.Details(tvshow: tvshow)
                } else {
                    Default(selection: .tvshows)
                }
            default:
                Default(selection: scene.sidebar)
            }
        }
        .animation(.default, value: scene.selection)
    }
}

extension DetailsView {
    
    struct Default: View {
        let selection: Router
        var body: some View {
            Text(selection.label.title)
                .font(.largeTitle)
                .padding(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background {
                    Image(systemName: selection.label.icon)
                        .resizable()
                        .scaledToFit()
                        .padding(40)
                        .opacity(0.1)
                }
        }
    }
}
