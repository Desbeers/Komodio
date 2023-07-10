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
/// On macOS, this is the struct passed to the `player` because its needs the 'resume' argument added.
struct MediaItem: Hashable, Identifiable, Codable {

    // MARK: Protocol conformance

    /// Confirm to `Equatable` protocol
    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        lhs.id == rhs.id
    }
    /// Confirm to `Hashable` protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: Variables

    /// The ID of the Media
    let id: String
    /// The KodiItem
    var item: (any KodiItem)?
    /// When playing this item, resume or not
    let resume: Bool

    // MARK: Init

    init(item: any KodiItem, resume: Bool = false) {
        self.id = item.id
        self.item = item
        self.resume = resume
    }

    // MARK: Coding keys

    /// Coding keys
    private enum CodingKeys: CodingKey {
        /// The ID of the item
        case id
        /// When playing this item, resume or not
        case resume
    }
}
