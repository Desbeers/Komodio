//
//  EpisodeView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Episode View

/// SwiftUI `View` for a single Episode (shared)
enum EpisodeView {

    /// Update an Episode
    /// - Parameter episode: The current Episode
    /// - Returns: The updated Episode
    static func update(episode: Video.Details.Episode) -> Video.Details.Episode? {
        let update = KodiConnector.shared.library.episodes.first { $0.id == episode.id }
        if let update, let details = SceneState.shared.detailSelection.item.kodiItem, details.media == .episode {
            SceneState.shared.detailSelection = .episode(episode: update)
        }
        return update
    }
}
