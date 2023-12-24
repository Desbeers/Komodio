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

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The episode
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(episode: Video.Details.Episode, router: Router) -> KodiCell {
        var stack: Router?
        var details: Router? = .episode(episode: episode)
#if canImport(UIKit)
        if router == .start || router == .favourites {
            stack = .episode(episode: episode)
            details = nil
        }
#endif
        return KodiCell(
            title: episode.title,
            subtitle: episode.subtitle,
            stack: stack,
            details: details
        )
    }
}
