//
//  MusicVideoView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Music Video View

/// SwiftUI `View` for a single Music Video (shared)
enum MusicVideoView {
    // Just a NameSpace here
}

extension MusicVideoView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The music video
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(musicVideo: Video.Details.MusicVideo, router: Router) -> KodiCell {
        var stack: Router?
        var details: Router? = .musicVideo(musicVideo: musicVideo)
#if canImport(UIKit)
        if router == .search || router == .favourites {
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
