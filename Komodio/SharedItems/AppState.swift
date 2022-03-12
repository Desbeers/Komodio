//
//  AppState.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI
import Combine

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
    /// Observe some kodi stuff
    private var observer: AnyCancellable?
//    /// Obsere notifications
//    @Published var Notification: KodiConnector.Method = .notifyAll {
//        didSet {
//            
//        }
//    }
    /// Init the AppState class
    init() {
        // Observe notifications
        self.observer = kodi.$notification.sink(receiveValue: {[weak self] notification in
            //debugPrint("AppState notification: \(notification)")
        })
    }

    /// Set the hovered Kodi item from the UI to the published Var
    /// - Parameter item: The Kodi item
    static func setHoveredMediaItem(item: MediaItem?) {
        Task { @MainActor in
            AppState.shared.hoveredMediaItem = item
        }
    }
}
