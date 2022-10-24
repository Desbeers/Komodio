//
//  MovieSetView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 24/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The TV show
    //let tvshow: Video.Details.TVShow
    /// The episode items to show in this view
    //@State private var episodes: [Video.Details.Episode] = []
    /// The movies to show in this view
    @State private var movies: [Video.Details.Movie] = []
    
    @Binding var status: SceneState.Status
    @Binding var movieSet: Video.Details.MovieSet?
    
    var body: some View {
        VStack {
            List(selection: $scene.selectedMovie) {
                ForEach(movies) { movie in
                    MoviesView.Item(movie: movie)
                        .tag(movie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar{
            if scene.selectedMovieSet != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        scene.selectedMedia = nil
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .onChange(of: movieSet) { movieSet in
            if let movieSet = self.movieSet {
                movies = kodi.library.movies
                    .filter({$0.setID == movieSet.setID})
            }
        }
    }
}

extension MovieSetView {
    
    struct Item: View {
        let movieSet: Video.Details.MovieSet
        var body: some View {
            HStack {
                KodiArt.Poster(item: movieSet)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                VStack(alignment: .leading) {
                    Text(movieSet.title)
                        .font(.headline)
                    Text("Movie Set")
                }
            }
        }
    }
}

extension MovieSetView {
    
    struct Details: View {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        var body: some View {
            VStack {
                if let _ = scene.selectedMovie {
                    MoviesView.Details()
                } else if let movieSet = scene.selectedMovieSet {
                        Text(movieSet.title)
                            .font(.largeTitle)
                } else {
                    Text("Movie Set")
                        .font(.largeTitle)
                }
            }
            .animation(.default, value: scene.selectedTVShow)
        }
    }
}
