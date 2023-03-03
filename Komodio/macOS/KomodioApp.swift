//
//  KomodioApp.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The Komodio App Scene (macOS)
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject private var kodi: KodiConnector = .shared
    /// Open new windows
    @Environment(\.openWindow) private var openWindow
    /// The body of the scene
    var body: some Scene {
        Window("Komodio", id: "Main") {
            MainView()
                .environmentObject(kodi)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                /// Hide the "New Player" window option
            }
        }
        /// Open a Video Window
        WindowGroup("Player", for: MediaItem.self) { $item in
            /// Check if `item` isn't `nil`
            if let item {
                KomodioPlayerView(video: item.item, resume: item.resume)
                    .navigationTitle(item.item.title)
            }
        }
        .defaultSize(width: 1280, height: 720)
        .defaultPosition(.center)
        .windowStyle(.hiddenTitleBar)
    }
}

extension KomodioApp {

    // MARK: Static settings

    /// The plaform
    static let platform: Parts.Platform = .macOS

    /// The default size of poster art
    static let posterSize = CGSize(width: 80, height: 120)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

}
