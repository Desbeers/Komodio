//
//  Parts.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Collection of loose parts (shared)
enum Parts {
    // Just a namespace here
}

extension Parts {

    /// Filter for media lists
    enum Filter: Equatable {
        /// Do not filter
        case none
        /// Filter for unwatched media
        case unwatched
        /// Filter by playlist
        case playlist(file: List.Item.File)
    }
}

extension Parts {

    /// The platforms supported by Komodio
    enum Platform {
        /// macOS
        case macOS
        /// tvOS
        case tvOS
        /// iPadOS
        case iPadOS
        /// visionOS
        case visionOS
    }
}
