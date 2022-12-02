//
//  MovieSetView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Movies in a Movie Set
struct MovieSetView: View {
    /// The selected set in the ``MoviesView``
    @Binding var selectedSet: MediaItem?
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The set movies to show in this view
    @State private var movies: [Video.Details.Movie] = []
    /// The optional selected movie in the set
    @State private var movie: Video.Details.Movie?
    /// The body of the View
    var body: some View {
        VStack {
            List(selection: $movie) {
                ForEach(movies) { movie in
                    MoviesView.Item(movie: movie)
                        .tag(movie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar {
            /// The selection might not be a set
            if selectedSet?.media == .movieSet {
                /// Show a 'back' button
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        selectedSet = nil
                        movie = nil
                        scene.details = .movies
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .task(id: selectedSet) {
            getMoviesFromSet()
            setMovieDetails()
        }
        .task(id: movie) {
            setMovieDetails()
        }
        .task(id: kodi.library.movies) {
            getMoviesFromSet()
            setMovieDetails()
        }
    }
    
    /// Get all movies from the selected set
    private func getMoviesFromSet() {
        /// The selection might not be a set
        if let set = selectedSet, set.media == .movieSet, let setID = Int(set.id) {
            movies = kodi.library.movies
                .filter({$0.setID == setID})
        }
        /// Update the optional selected movie
        if let movie {
            self.movie = movies.first(where: ({$0.id == movie.id}))
        }
    }
    
    /// Set the details of a selected movie
    private func setMovieDetails() {
        if let movie {
            print("Movie details from MovieSet set")
            scene.details = .movie(movie: movie)
        }
    }
}

extension MovieSetView {
    
    /// SwiftUI View for a `MovieSet` in ``MoviesView``
    struct Item: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet
        /// The body of the view
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
    
    /// SwiftUI View for the details of a `MovieSet`
    struct Details: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet
        /// The body of the view
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
