//
//  VideoItem.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import Foundation
import SwiftlyKodiAPI

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
