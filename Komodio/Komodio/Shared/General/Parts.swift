//
//  Parts.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import Foundation

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
    enum Filter {
        /// Do not filter
        case none
        /// Filter for unwatched media
        case unwatched
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

extension Parts {

    /// Convert 'seconds' to a formatted string
    /// - Parameters:
    ///   - seconds: The seconds
    ///   - style: The time format
    /// - Returns: A formatted String
    static func secondsToTime(seconds: Int, style: DateComponentsFormatter.UnitsStyle = .brief) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        return formatter.string(from: TimeInterval(Double(seconds)))!
    }
}
