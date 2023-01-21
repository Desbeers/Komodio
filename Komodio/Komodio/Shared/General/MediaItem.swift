//
//  MediaItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Structure for a Komodio 'Media Item' (shared)
///
/// Some lists in Komodio, eg Movies and Music Videos, do contain a mixure of `KodiItems`
/// To make an item in such list selectable, this `MediaItem` struct is used to wrap the item.
///
/// Also, on macOS, this is the struct passed to the `player` because its needs the 'resume' argument added.
struct MediaItem: Hashable, Identifiable, Codable {

    // MARK: Protocol conformance

    /// Confirm to `Equatable` protocol
    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        lhs.id == rhs.id && lhs.item.playcount == rhs.item.playcount
    }
    /// Confirm to `Hashable` protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: Variables

    /// The ID of the item
    var id: String
    /// The kind of media
    var media: Library.Media = .movie
    /// When playing this item, resume or not
    var resume: Bool = false
    /// The KodiItem
    var item: any KodiItem = Audio.Details.Stream()

    /// Coding keys
    private enum CodingKeys: CodingKey {
        /// The ID of the item
        case id
        /// When playing this item, resume or not
        case resume
    }
}
