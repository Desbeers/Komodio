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
        let update = KodiConnector.shared.library.tvshows.first { $0.id == tvshow.id }
        if let update, let details = SceneState.shared.details.item.kodiItem, details.media == .tvshow {
            SceneState.shared.details = .tvshow(tvshow: update)
        }
        return update
    }
}
