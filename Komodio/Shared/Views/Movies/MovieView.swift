//
//  MovieView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movie View

/// SwiftUI View for a single Movie (shared)
enum MovieView {

    // MARK: Private functions

    /// Update a Movie
    ///
    /// On `tvOS`, Movie details are shown in its own View so it needs to update itself when movie details are changed
    ///
    /// - Parameter movie: The movie to update
    /// - Returns: If update is found, the updated Movie, else `nil`
    static func updateMovie(movie: Video.Details.Movie) -> Video.Details.Movie? {
        if let update = KodiConnector.shared.library.movies.first(where: { $0.id == movie.id }), update != movie {
            return update
        }
        return nil
    }
}
