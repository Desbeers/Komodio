//
//  MusicVideoView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Music Video View

/// SwiftUI `View` for a single Music Video (shared)
enum MusicVideoView {

    /// Update a Music Video
    /// - Parameter musicVideo: The current Music Video
    /// - Returns: The updated Music Video
    static func update(musicVideo: Video.Details.MusicVideo) -> Video.Details.MusicVideo? {
        let update = KodiConnector.shared.library.musicVideos.first { $0.id == musicVideo.id }
        if let update, let details = SceneState.shared.details.item.kodiItem, details.media == .musicVideo {
            SceneState.shared.details = .musicVideo(musicVideo: update)
        }
        return update
    }
}
