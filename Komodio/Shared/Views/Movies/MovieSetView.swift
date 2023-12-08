//
//  MovieSetView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movie Set View

/// SwiftUI `View` for all Movies in a Movie Set (shared)
struct MovieSetView: View {
    /// The movie set
    let movieSet: Video.Details.MovieSet
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "movieset", method: .year, order: .ascending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            content
        }
        .task(id: kodi.library.movies) {
            getMoviesFromSet()
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {

#if os(macOS)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(title: movieSet.title)
            },
            content: {
                CollectionView(
                    collection: $collection,
                    sorting: $sorting,
                    collectionStyle: scene.collectionStyle,
                    showIndex: false
                )
            },
            buttons: {
                Buttons.CollectionSort(sorting: $sorting, media: .movie)
            }
        )
#endif

#if os(tvOS) || os(iOS) || os(visionOS)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(title: movieSet.title)
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    CollectionView(
                        collection: $collection,
                        sorting: $sorting,
                        collectionStyle: .asPlain,
                        showIndex: false
                    )
                    .frame(width: StaticSetting.contentWidth, alignment: .leading)
                    .backport.focusSection()
                    MovieSetView.Details(movieSet: movieSet)
                }
            },
            buttons: {
                Buttons.CollectionSort(sorting: $sorting, media: .movie)
            }
        )
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
        let movies = kodi.library.movies
            .filter { $0.setID == movieSet.setID }
            .filter { scene.movieItems.contains($0.movieID) }
        collection = movies.anykodiItem()
    }
}

extension MovieSetView {

    /// Update a Movie Set
    /// - Parameter movieset: The current Movie Set
    /// - Returns: The optional updated Movie Set
    static func update(movieSet: Video.Details.MovieSet) -> Video.Details.MovieSet? {
        if let update = KodiConnector.shared.library.movieSets.first(where: { $0.id == movieSet.id }), update != movieSet {
            return update
        }
        return nil
    }
}

extension MovieSetView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The movie set
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(movieSet: Video.Details.MovieSet, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .movieSet(movieSet: movieSet)
        let stack: Router = .movieSet(movieSet: movieSet)
        return KodiCell(
            title: movieSet.title,
            subtitle: "Movie Set",
            stack: stack,
            details: details
        )
    }
}
