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
    @State var sorting = SwiftlyKodiAPI.List.Sort(id: "movieset", method: .year, order: .ascending)

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .task(id: movieSet) {
                scene.selectedKodiItem = movieSet
                scene.details = .movieSet(movieSet: movieSet)
                getMoviesFromSet()
            }
            .onChange(of: kodi.library.movies) { _ in
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
                            scene.selectedKodiItem = movie
                            scene.details = .movie(movie: movie)
                        },
                        label: {
                            MovieView.Item(movie: movie, sorting: sorting)
                        }
                    )
                    .buttonStyle(.listButton(selected: scene.selectedKodiItem?.id == movie.id))
                    Divider()
                }
            }
            .padding()
        }
        .animation(.default, value: sorting)
#endif

#if os(tvOS) || os(iOS)
        ContentWrapper(
            header: {
                ZStack {
                    PartsView.DetailHeader(title: movieSet.title)
                    if KomodioApp.platform == .tvOS {
                        Buttons.PlayedState(item: movieSet)
                            .padding(.trailing, 50)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                            .padding(.leading, 50)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .labelStyle(.headerLabel)
            }, content: {
                VStack {
                    if !movieSet.description.isEmpty {
                        PartsView.TextMore(item: movieSet)
                            .backport.focusSection()
                            .padding(.bottom, 20)
                    }
                    LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                        ForEach(movies) { movie in
                            NavigationLink(value: movie) {
                                MovieView.Item(movie: movie, sorting: sorting)
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .backport.focusSection()
                }
            }
        )
        .backport.cardButton()
        .animation(.default, value: movies.map { $0.id })
        .toolbar {
            if KomodioApp.platform == .iPadOS {
                Buttons.PlayedState(item: movieSet)
                    .labelStyle(.titleAndIcon)
                Pickers.ListSortSheet(sorting: $sorting, media: .movie)
                    .labelStyle(.titleAndIcon)
            }
        }
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
            if let sorting = scene.listSortSettings.first(where: { $0.id == self.sorting.id }) {
                self.sorting = sorting
            }
            /// Get all the movies from the set
            movies = kodi.library.movies
                .filter { $0.setID == movieSet.setID }
                .filter { scene.movieItems.contains($0.movieID) }
                .sorted(sortItem: sorting)
            scene.navigationSubtitle = movieSet.title
        }
    }
}
