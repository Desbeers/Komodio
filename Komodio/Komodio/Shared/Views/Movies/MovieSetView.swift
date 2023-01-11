//
//  MovieSetView.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Movies in a Movie Set
struct MovieSetView: View {
    /// The movie set
    let movieSet: Video.Details.MovieSet
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The set movies to show in this view
    @State private var movies: [Video.Details.Movie] = []
    /// The optional selected movie in the set
    @State private var selectedMovie: Video.Details.Movie?
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]
    /// The body of the View
    var body: some View {

        // MARK: Body of the View

        content
            .task(id: movieSet) {
                getMoviesFromSet()
            }
            .task(id: selectedMovie) {
                setMovieDetails()
            }
            .task(id: kodi.library.movies) {
                getMoviesFromSet()
            }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        VStack {
            List(selection: $selectedMovie) {
                ForEach(movies) { movie in
                    MoviesView.Item(movie: movie)
                        .tag(movie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
#endif

#if os(tvOS)
        VStack {
            MovieSetView.Details(movieSet: movieSet)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie, label: {
                            MoviesView.Item(movie: movie)
                        })
                    }
                }
                .padding(80)

            }
        }
        .buttonStyle(.card)
#endif

    }

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getMoviesFromSet() {
        /// The selection might not be a set
        if movieSet.media == .movieSet {
            /// Get all the movies from the set
            movies = kodi.library.movies
                .filter({$0.setID == movieSet.setID})
                .sorted(by: {$0.year < $1.year})
            /// Update the optional selected movie
            if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
                self.selectedMovie = movie
            }
        } else {
            /// Make sure we don't have an old selection
            selectedMovie = nil
        }
    }

    /// Set the details of a selected movie
    private func setMovieDetails() {
        if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
            scene.details = .movie(movie: movie)
        }
    }
}

// MARK: Extensions

extension MovieSetView {

    /// SwiftUI View for a `MovieSet` in ``MoviesView``
    struct Item: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet
        /// The body of the View
        var body: some View {
            HStack {
                KodiArt.Poster(item: movieSet)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: movieSet)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(movieSet.title)
                        .font(.headline)
                    Text("Movie Set")
                }
#endif

            }
        }
    }
}

extension MovieSetView {

    // MARK: Details of a  Movie Set

    /// SwiftUI View for the details of a `MovieSet`
    struct Details: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(movieSet.title)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: movieSet)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                    Text(movieSet.plot)
                        .font(.system(size: 18))
                        .lineSpacing(8)
                        .padding(.vertical)
                }
                .padding(40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(file: movieSet.fanart)
#endif

#if os(tvOS)
            HStack {
                KodiArt.Fanart(item: movieSet)
                    .cornerRadius(10)
                VStack {
                    Text(movieSet.title)
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.bottom)
                    Text(movieSet.plot)
                }
            }
            .padding(40)
            .background(file: movieSet.fanart)
#endif

        }
    }
}
