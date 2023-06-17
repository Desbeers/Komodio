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
    /// Just a namespace here...
}

extension Parts {

    /// The state of  loading a View
    enum Status {
        /// The Task is loading the items
        case loading
        /// No items where found by the `Task`
        case empty
        /// The `Task` is done and items where found
        case ready
        /// The host is offline
        case offline
        /// The message when offline
        var offlineMessage: String {
            "Komodio is not connected to a host"
        }
    }
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
    }
}
