//
//  AppState.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Class to observe the Komodio App state
class AppState: ObservableObject {
    /// The shared instance of this AppState class
    static let shared = AppState()
    /// The currently selected host
    @Published var host: HostItem?
    /// Init the class; get host information
    private init() {
        self.host = AppState.getHost()
    }
}

extension AppState {
    
    /// Save the hosts to the cache
    /// - Parameter hosts: The array of hosts
    static func saveHost(host: HostItem) {
        if AppState.shared.host != host {
            do {
                try Cache.set(key: "MyHost", object: host, root: true)
            } catch {
                logger("Error saving MyHost")
            }
            Task { @MainActor in
                KodiConnector.shared.state = .none
                AppState.shared.host = host
            }
        }
    }
    
    /// Get the configured host
    /// - Returns: An optional host
    static func getHost() -> HostItem? {
        logger("Get the host")
        if let host = Cache.get(key: "MyHost", as: HostItem.self, root: true) {
            return host
        }
        /// No host found
        return nil
    }
}
