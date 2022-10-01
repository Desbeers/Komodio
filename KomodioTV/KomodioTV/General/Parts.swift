//
//  Parts.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of loose parts
struct Parts {
    /// Just a Namespace here...
}

extension Parts {
    
    /// The sort order of lists
    enum Sort: String, CaseIterable {
        case title = "Sort by title"
        case runtime = "Sort by duration"
    }
}

extension Parts {
    
    /// The state of  loading a View
    enum State {
        /// The Task is loading the items
        case loading
        /// No items where found by the `Task`
        case empty
        /// The `Task` is done and items where found
        case ready
        /// The host is offline
        case offline
        /// The message when offline
        var offlineMessage: Text {
            Text("Komodio is not connected to a host")
        }
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
