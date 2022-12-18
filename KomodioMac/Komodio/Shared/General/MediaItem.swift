//
//  MediaItem.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Struct for a Komodio Media Item
struct MediaItem: Hashable, Identifiable, Codable {
    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        lhs.id == rhs.id && lhs.musicVideos == rhs.musicVideos && lhs.item.playcount == rhs.item.playcount
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    /// The ID of the item
    var id: String
    /// The kind of media
    var media: Library.Media = .movie
    /// When playing this item, resume or not
    var resume: Bool = false
    /// The KodiItem
    var item: any KodiItem = Audio.Details.Stream()
    /// Optional Music Videos
    var musicVideos: [Video.Details.MusicVideo]?
    /// Optional TV show Episodes
    var episodes: [Video.Details.Episode]?
    /// Make it codable
    enum CodingKeys: CodingKey {
        case id
        case resume
    }
}
