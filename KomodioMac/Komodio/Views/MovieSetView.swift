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
    /// The movies to show in this view
    @State private var movies: [Video.Details.Movie] = []
    /// The body of the View
    var body: some View {
        VStack {
            List(selection: $scene.selection.movie) {
                ForEach(movies) { movie in
                    MoviesView.Item(movie: movie)
                        .tag(movie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar{
            if scene.selection.movieSet != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        scene.selection = SceneState.Selection(route: .movies)
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .task(id: scene.selection.movieSet) {
            if let movieSet = scene.selection.movieSet {
                movies = kodi.library.movies
                    .filter({$0.setID == movieSet.setID})
            }
        }
//        .onChange(of: movieSet) { movieSet in
//            if let movieSet = self.movieSet {
//                movies = kodi.library.movies
//                    .filter({$0.setID == movieSet.setID})
//            }
//        }
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
        /// The movie set
        let movieSet: Video.Details.MovieSet
        var body: some View {
            VStack {
                VStack {
                    KodiArt.Fanart(item: movieSet)
                        .padding(.bottom, 40)
                    Text(movieSet.title)
                        .font(.largeTitle)
                    Text(movieSet.plot)
                }
                .padding(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    KodiArt.Fanart(item: movieSet)
                        .scaledToFill()
                        .opacity(0.2)
                )
            }
        }
    }
}
