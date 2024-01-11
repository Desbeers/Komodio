//
//  MediaItem.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Structure for a Komodio 'Media Item' (shared)
///
/// - Note: Passed to ``KomodioPlayerView`` when playing a Kodi item

struct MediaItem: Codable, Hashable {
    /// The Kodi ID of the item
    let id: Library.ID
    /// The tile of the item
    let title: String
    /// The kind of Media
    let media: Library.Media
    /// When playing this item, resume or not
    let resume: Bool
}
