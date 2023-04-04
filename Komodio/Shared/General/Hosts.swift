//
//  Hosts.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Helper functions for Host Items
enum Hosts {
    // Just a namespace here
}

extension Hosts {

    /// Get the optional configured hosts
    /// - Returns: All configured hosts
    static func getConfiguredHosts() -> [HostItem]? {
        /// The KodiConnector model
        let kodi: KodiConnector = .shared
        if !kodi.configuredHosts.isEmpty {
            return kodi.configuredHosts.sorted { $0.isSelected && !$1.isSelected }
        }
        return nil
    }

    /// Get the optional new hosts
    /// - Returns: All new hosts
    static func getNewHosts() -> [HostItem]? {
        /// The KodiConnector model
        let kodi: KodiConnector = .shared
        if !kodi.bonjourHosts.filter({ $0.new }).isEmpty {
            var hosts: [HostItem] = []
            for host in kodi.bonjourHosts where host.new {
                hosts.append(
                    HostItem(
                        name: host.name,
                        ip: host.ip,
                        media: .video,
                        player: .stream,
                        status: .new
                    )
                )
            }
            return hosts
        }
        return nil
    }
}
