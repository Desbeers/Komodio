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
    // Just a namespace
}

extension MovieView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The movie
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(movie: Video.Details.Movie, style: ScrollCollectionStyle) -> KodiCell {
#if os(macOS)
        let details: Router = .movie(movie: movie)
        let stack: Router? = nil
#else
        let details: Router? = nil
        let stack: Router = .movie(movie: movie)
#endif
        return KodiCell(
            title: movie.title,
            subtitle: movie.genre.joined(separator: "∙"),
            stack: stack,
            details: details
        )
    }
}
