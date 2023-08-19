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
    // Just a NameSpace here
}

extension MusicVideoView {

    /// Update a Music Video
    /// - Parameter musicVideo: The current Music Video
    /// - Returns: The updated Music Video
    static func update(musicVideo: Video.Details.MusicVideo) -> Video.Details.MusicVideo? {
        let update = KodiConnector.shared.library.musicVideos.first { $0.id == musicVideo.id }
        if let update, let details = SceneState.shared.detailSelection.item.kodiItem, details.media == .musicVideo {
            SceneState.shared.detailSelection = .musicVideo(musicVideo: update)
        }
        return update
    }
}

extension MusicVideoView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The music video
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(musicVideo: Video.Details.MusicVideo, style: ScrollCollectionStyle) -> KodiCell {
        var stack: Router?
        var details: Router? = .musicVideo(musicVideo: musicVideo)
#if canImport(UIKit)
        let scene = SceneState.shared
        if scene.mainSelection == .search {
            stack = .musicVideo(musicVideo: musicVideo)
            details = nil
        }
#endif
        return KodiCell(
            title: musicVideo.title,
            subtitle: musicVideo.artist.joined(separator: "∙"),
            stack: stack,
            details: details
        )
    }
}
