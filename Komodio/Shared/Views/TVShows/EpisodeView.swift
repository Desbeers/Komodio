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
    // Just a namespace
}

extension EpisodeView {

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

extension EpisodeView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The episode
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(episode: Video.Details.Episode, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .episode(episode: episode)
        let stack: Router? = nil
        return KodiCell(
            title: episode.title,
            subtitle: episode.subtitle,
            stack: stack,
            details: details
        )
    }
}
