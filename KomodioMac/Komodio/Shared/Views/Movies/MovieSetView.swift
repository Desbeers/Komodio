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
    @State private var selectedMovie: Video.Details.Movie?
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]
    /// The body of the View
    var body: some View {
        content
            .task(id: selectedSet) {
                getMoviesFromSet()
            }
            .task(id: selectedMovie) {
                setMovieDetails()
            }
            .task(id: kodi.library.movies) {
                getMoviesFromSet()
                setMovieDetails()
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
        .toolbar {
            /// The selection might not be a set
            if selectedSet?.media == .movieSet {
                /// Show a 'back' button
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        selectedSet = nil
                        selectedMovie = nil
                        scene.details = .movies
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
    }
#endif

#if os(tvOS)
    /// The content of the View
    var content: some View {
        HStack {
            if let set = selectedSet?.movieSet {
                MovieSetView.Details(movieSet: set)
            }
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { movie in
                        Button(action: {
                            selectedMovie = movie
                            scene.showDetails = true
                        }, label: {
                            MoviesView.Item(movie: movie)
                        })
                    }
                }
            }
        }
        .buttonStyle(.card)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .onDisappear {
            selectedSet = nil
            selectedMovie = nil
            scene.details = .movies
        }
        .setSafeAreas()
    }
#endif

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getMoviesFromSet() {
        /// The selection might not be a set
        if let set = selectedSet, set.media == .movieSet, let setID = Int(set.id) {
            movies = kodi.library.movies
                .filter({$0.setID == setID})
        }
        /// Update the optional selected movie
        if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
            self.selectedMovie = movie
        }
    }

    /// Set the details of a selected movie
    private func setMovieDetails() {
        if selectedSet?.media == .movieSet, let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
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
