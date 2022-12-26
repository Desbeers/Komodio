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

    // MARK: Content of the MovieSetView

#if os(macOS)
    /// The content of the View
    var content: some View {
        VStack {
            List(selection: $selectedMovie) {
                ForEach(movies) { movie in
                    MoviesView.Item(movie: movie)
                        .tag(movie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
    }
#endif

#if os(tvOS)
    /// The content of the View
    var content: some View {
        VStack {
            MovieSetView.Details(movieSet: movieSet)
            ScrollView {
                HStack {
                    ForEach(movies) { movie in
                        NavigationLink(value: movie, label: {
                            MoviesView.Item(movie: movie)
                        })
                    }
                }
                .padding(80)

            }
            .frame(maxWidth: 400)

        }
        .buttonStyle(.card)
    }
#endif

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getMoviesFromSet() {
        /// The selection might not be a set
        if movieSet.media == .movieSet {
            movies = kodi.library.movies
                .filter({$0.setID == movieSet.setID})
        } else {
            selectedMovie = nil
        }
        /// Update the optional selected movie
        if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
            self.selectedMovie = movie
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

    /// SwiftUI View for the details of a `MovieSet`
    struct Details: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet
        /// The body of the View
        var body: some View {
            VStack {
                Text(movieSet.title)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                KodiArt.Fanart(item: movieSet)
                    .padding(.bottom, 40)
                Text(movieSet.plot)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
#if os(macOS)
            .background(
                KodiArt.Fanart(item: movieSet)
                    .scaledToFill()
                    .opacity(0.2)
            )
#endif
        }
    }
}
