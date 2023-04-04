//
//  TVShowView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: TV show View

/// SwiftUI View for a single TV show (shared)
enum TVShowView {

    // MARK: Private functions

    /// Update a TV show
    ///
    /// On `tvOS`, TV show details are shown in its own View so it needs to update itself when movie details are changed
    ///
    /// - Parameter tvshow: The TV show to update
    /// - Returns: If update is found, the updated Movie, else `nil`
    static func updateTVshow(tvshow: Video.Details.TVShow) -> Video.Details.TVShow? {
        if let update = KodiConnector.shared.library.tvshows.first(where: { $0.id == tvshow.id }), update != tvshow {
            return update
        }
        return nil
    }
}
