//
//  MovieSetView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Movies in a Movie Set (shared)
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
    /// The sorting
    @State var sorting = ListSort.Item(id: "movieset", method: .year, order: .forward)
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .task(id: movieSet) {
                getMoviesFromSet()
                setMovieSetDetails()
            }
            .task(id: selectedMovie) {
                setMovieDetails()
            }
            .task(id: kodi.library.movies) {
                getMoviesFromSet()
            }
            .task(id: kodi.library.movieSets) {
                setMovieSetDetails()
            }
            .animation(.default, value: sorting)
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        VStack {
            List(selection: $selectedMovie) {
                Pickers.ListSortPicker(sorting: $sorting, media: .movie)
                ForEach(movies.sorted(sortItem: sorting)) { movie in
                    MovieView.Item(movie: movie)
                        .tag(movie)
                }
            }
        }
#endif

#if os(tvOS)
        VStack {
            DetailView()
            HStack {
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                Buttons.PlayedState(item: movieSet)
            }
            .labelStyle(.playLabel)
            .buttonStyle(.card)
            .frame(maxWidth: .infinity)
            .focusSection()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies.sorted(sortItem: sorting)) { movie in
                        NavigationLink(value: movie, label: {
                            MovieView.Item(movie: movie)
                        })
                    }
                }
                .padding(40)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .focusSection()
        }
        .buttonStyle(.card)
        .ignoresSafeArea(edges: .bottom)
#endif

    }

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getMoviesFromSet() {

        /// The selection might not be a set
        if movieSet.media == .movieSet {
            /// Set the ID of the sorting
            self.sorting.id = movieSet.id
            /// Check if the setting is not the default
            if let sorting = scene.listSortSettings.first(where: {$0.id == self.sorting.id}) {
                self.sorting = sorting
            }
            /// Get all the movies from the set
            movies = kodi.library.movies
                .filter({$0.setID == movieSet.setID})
                .sorted(using: [
                  KeyPathComparator(\.year),
                  KeyPathComparator(\.sortByTitle)
                ])
            /// Update the optional selected movie
            if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
                self.selectedMovie = movie
            }
        } else {
            /// Make sure we don't have an old selection
            selectedMovie = nil
        }
    }

    /// Set the details of a selected movie set
    private func setMovieSetDetails() {
        if movieSet.media == .movieSet, selectedMovie == nil, let movieSet = kodi.library.movieSets.first(where: {$0.id == movieSet.id}) {
            scene.details = .movieSet(movieSet: movieSet)
        }
    }

    /// Set the details of a selected movie
    private func setMovieDetails() {
        if let selectedMovie, let movie = movies.first(where: ({$0.id == selectedMovie.id})) {
            scene.details = .movie(movie: movie)
        }
    }
}

extension MovieSetView {

    // MARK: Movie Set item

    /// SwiftUI View for a `MovieSet` item
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

    // MARK: Movie Set details

    /// SwiftUI View for the details of a `MovieSet`
    struct Details: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Group {

#if os(macOS)
                VStack {
                    Text(movieSet.title)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: movieSet)
                        .fanartStyle(item: movieSet)
                    Buttons.PlayedState(item: movieSet)
                        .padding()
                        .labelStyle(.playLabel)
                        .buttonStyle(.playButton)
                    Text(movieSet.plot)
                }
                .detailsFontStyle()
                .detailsWrapper()
#endif

#if os(tvOS)
                HStack {
                    KodiArt.Fanart(item: movieSet)
                        .fanartStyle(item: movieSet)
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
                .frame(maxWidth: .infinity)
#endif

            }
            .background(item: movieSet)
            .animation(.default, value: movieSet)
        }
    }
}
