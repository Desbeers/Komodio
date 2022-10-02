//
//  Parts.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of loose parts
enum Parts {
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
    
    /// Types of overlay for a KodiItem
    enum Overlay {
        case none
        case title
        case runtime
        case timeToGo
        case movieSet
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

extension Parts {
    
    /// The files Komodio can play
    static let fileExtension: [String] = ["caf", "ttml", "au", "ts", "mqv", "pls", "flac", "dv", "amr", "mp1", "mp3", "ac3", "loas", "3gp", "aifc", "m2v", "m2t", "m4b", "m2a", "m4r", "aa", "webvtt", "aiff", "m4a", "scc", "mp4", "m4p", "mp2", "eac3", "mpa", "vob", "scc", "aax", "mpg", "wav", "mov", "itt", "xhe", "m3u", "mts", "mod", "vtt", "m4v", "3g2", "sc2", "aac", "mp4", "vtt", "m1a", "mp2", "avi"]
}
