//
//  KomodioApp.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The Komodio App Scene
@main struct KomodioApp: App {
    /// The AppState model
    @StateObject private var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject private var kodi: KodiConnector = .shared
    /// Open new windows
    @Environment(\.openWindow) private var openWindow
    /// The body of the scene
    var body: some Scene {
        WindowGroup(id: "Main") {
            MainView()
                .environmentObject(kodi)
                .environmentObject(appState)
                .task {
                    if kodi.state == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Window") {
                    openWindow(id: "Main")
                }
            }
        }
        /// Open a Video Window
        WindowGroup("Player", for: MediaItem.self) { $item in
            /// Check if `item` isn't `nil`
            if let item = item {
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

    /// The default size of poster art
    static let posterSize = CGSize(width: 80, height: 120)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

}
