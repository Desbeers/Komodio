//
//  TVShowView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: TV show View

/// SwiftUI `View` for a single TV show (shared)
enum TVShowView {

    /// Update a TVshow
    /// - Parameter tvshow: The current TV show
    /// - Returns: The updated TV show
    static func update(tvshow: Video.Details.TVShow) -> Video.Details.TVShow? {
        if let update = KodiConnector.shared.library.tvshows.first(where: { $0.id == tvshow.id }), update != tvshow {
            return update
        }
        return nil
    }
}

extension TVShowView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The tvshow
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(tvshow: Video.Details.TVShow, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .tvshow(tvshow: tvshow)
        let stack: Router = .tvshow(tvshow: tvshow)
        return KodiCell(
            title: tvshow.title,
            subtitle: tvshow.genre.joined(separator: "∙"),
            stack: stack,
            details: details
        )
    }
}
