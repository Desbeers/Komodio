//
//  Parts.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// Collection of loose parts
enum Parts {
    /// Just a Namespace here...
}

extension Parts {

    /// The message to show in ``DetailView``
    struct DetailMessage: View {
        let title: String
        let message: String
        var body: some View {
            Text(title)
                .font(.system(size: 50))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.bottom)
            Text(.init(message))
                .font(.system(size: 20))
                .opacity(0.6)
                .padding(.bottom)
        }
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

    /// Filter for media lists
    enum Filter {
        case none
        case unwatched
    }
}
