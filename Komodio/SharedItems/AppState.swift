//
//  AppState.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// A class with the state of the application
/// - UI selection
/// - Connection with the Kodi host
final class AppState: ObservableObject {
    /// The shared instance of this KodiConnector class
    static let shared = AppState()
    /// The bridge to communicate to the Kodi host
    let kodi: KodiConnector = .shared
    /// The selected item in the sidebar of the application
    @Published var sidebarSelection: Int?
    /// The selected item in the sidebar of the application
    @Published var hoveredMediaItem: MediaItem?
    /// Init the AppState class
    /// - Set the IP address for the Kodo host
//    init() {
//        kodi.connectToHost(kodiHost: HostItem(ip: "127.0.0.1"))
//    }
    
    //var filter = KodiFilter(media: .none)
    //@Published var filter = KodiFilter(media: .none)
    
    
    /// Set the hovered Kodi item from the UI to the published Var
    /// - Parameter item: The Kodi item
    static func setHoveredMediaItem(item: MediaItem?) {
        Task { @MainActor in
            AppState.shared.hoveredMediaItem = item
        }
    }
}
