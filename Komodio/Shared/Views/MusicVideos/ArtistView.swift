//
//  ArtistView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Artist View

/// SwiftUI `View` for a single Artist (shared)
enum ArtistView {
    // Just a NameSpace here
}

extension ArtistView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The artist
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(artist: Audio.Details.Artist, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .musicVideoArtist(artist: artist)
        let stack: Router = .musicVideoArtist(artist: artist)
        var poster = CGSize(width: StaticSetting.posterSize.width, height: StaticSetting.posterSize.width)
        if style == .asList {
            poster.width = StaticSetting.posterSize.height
            poster.height = StaticSetting.posterSize.height
        }
        return KodiCell(
            poster: poster,
            title: artist.title,
            subtitle: artist.genre.joined(separator: "∙"),
            stack: stack,
            details: details
        )
    }
}
