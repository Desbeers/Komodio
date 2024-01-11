//
//  MusicVideoAlbumView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Album View

/// SwiftUI `View` for a music video album (shared)
enum MusicVideoAlbumView {
    // Just a namespace
}

extension MusicVideoAlbumView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The album
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(musicVideoAlbum: Video.Details.MusicVideoAlbum, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .musicVideoAlbum(musicVideoAlbum: musicVideoAlbum)
        let stack: Router? = nil
        return KodiCell(
            title: musicVideoAlbum.title,
            subtitle: musicVideoAlbum.artist.artist,
            stack: stack,
            details: details
        )
    }
}
