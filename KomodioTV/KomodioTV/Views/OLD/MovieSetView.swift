//
//  MovieSetView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for a set of Movie items
struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    //@EnvironmentObject var appState: AppState
    /// The movie set to show in this View
    let set: Video.Details.MovieSet
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The body of this View
    var body: some View {
        VStack {
            Text(set.title)
                .font(.title)
            /// TabView will crash when movies is still empty
            if !movies.isEmpty {
                TabView {
                    ForEach(movies) { movie in
                        HStack {
                            MoviesView.MovieItem(movie: movie)
                            VStack {
                                Text(movie.title)
                                    .font(.headline)
                                Text(movie.year.description)
                                    .font(.subheadline)
                                Text(movie.plot)
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
            }
        }
        .task(id: kodi.library.movies) {
            movies = kodi.library.movies.filter( {$0.setID == set.setID } ).sorted {$0.year < $1.year}
        }
    }
}
