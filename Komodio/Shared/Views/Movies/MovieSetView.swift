//
//  MovieSetView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movie Set View

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
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "movieset", method: .year, order: .ascending)

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .task(id: kodi.library.movies) {
                getMoviesFromSet()
            }
            .onChange(of: sorting) { sorting in
                movies.sort(sortItem: sorting)
            }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
#if os(macOS)
        ScrollView {
            KodiListSort.PickerView(sorting: $sorting, media: .movie)
                .padding()
            LazyVStack {
                ForEach(movies) { movie in
                    Button(
                        action: {
                            scene.details = .movie(movie: movie)
                        },
                        label: {
                            MovieView.Item(movie: movie, sorting: sorting)
                        }
                    )
                    .buttonStyle(.kodiItemButton(kodiItem: movie))
                    Divider()
                }
            }
            .padding()
        }
        .animation(.default, value: sorting)
#endif

#if os(tvOS) || os(iOS)
        ContentView.Wrapper(
            scroll: false,
            header: {
                ZStack {
                    PartsView.DetailHeader(title: movieSet.title, subtitle: "\(movies.count) movies")
                    if KomodioApp.platform == .tvOS {
                        Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                            .labelStyle(.headerLabel)
                            .padding(.leading, 50)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    ScrollView {
                        LazyVStack {
                            ForEach(movies) { movie in
                                NavigationLink(value: Router.movie(movie: movie)) {
                                    MovieView.Item(movie: movie, sorting: sorting)
                                }
                                .padding(.bottom, KomodioApp.posterSize.height / 20)
                            }
                        }
                        .padding(.vertical, KomodioApp.contentPadding)
                    }
                    .frame(width: KomodioApp.columnWidth, alignment: .leading)
                    .backport.focusSection()
                    MovieSetView.Details(movieSet: movieSet)
                }
            }
        )
        .backport.cardButton()
        .toolbar {
            if KomodioApp.platform == .iPadOS {
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                    .labelStyle(.titleAndIcon)
            }
        }
#endif
    }

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getMoviesFromSet() {
        /// Set the ID of the sorting
        self.sorting.id = movieSet.id
        /// Check if the setting is not the default
        if let sorting = scene.listSortSettings.first(where: { $0.id == self.sorting.id }) {
            self.sorting = sorting
        }
        /// Get all the movies from the set
        movies = kodi.library.movies
            .filter { $0.setID == movieSet.setID }
            .filter { scene.movieItems.contains($0.movieID) }
            .sorted(sortItem: sorting)
    }
}

extension MovieSetView {

    /// Update a Movie Set
    /// - Parameter movieset: The current Movie Set
    /// - Returns: The updated Movie Set
    static func update(movieSet: Video.Details.MovieSet) -> Video.Details.MovieSet? {
        let update = KodiConnector.shared.library.movieSets.first { $0.id == movieSet.id }
        if let update, let details = SceneState.shared.details.item.kodiItem, details.media == .movieSet {
            SceneState.shared.details = .movieSet(movieSet: update)
        }
        return update
    }
}
