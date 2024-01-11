//
//  TVShowView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: TV show View

/// SwiftUI `View` for a single TV show (shared)
enum TVShowView {
    // Just a namespace
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
