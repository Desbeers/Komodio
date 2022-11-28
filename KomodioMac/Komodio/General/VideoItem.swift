//
//  VideoItem.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Struct for a Komodio Video Item
struct VideoItem: Hashable, Codable {
    static func == (lhs: VideoItem, rhs: VideoItem) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let resume: Bool
    var video: any KodiItem = Audio.Details.Stream()
    
    enum CodingKeys: CodingKey {
        case id
        case resume
    }
}

/// Struct for a Komodio Media Item
struct MediaItem: Hashable {
    var id: String
    var media: Library.Media
}
