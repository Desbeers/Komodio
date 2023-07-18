//
//  MovieView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Movie View

/// SwiftUI `View` for a single Movie (shared)
enum MovieView {

    /// Update a Movie
    /// - Parameter movie: The current Movie
    /// - Returns: The updated Movie
    static func update(movie: Video.Details.Movie) -> Video.Details.Movie? {
        let update = KodiConnector.shared.library.movies.first { $0.id == movie.id }
        if let update, let details = SceneState.shared.detailSelection.item.kodiItem, details.media == .movie {
            SceneState.shared.detailSelection = .movie(movie: update)
        }
        return update
    }
}
