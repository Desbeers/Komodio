//
//  KomodioApp.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Komodio App

/// The Komodio App Scene (shared)
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject private var kodi: KodiConnector = .shared

    // MARK: Body of the Scene

    /// The body of the Scene
    var body: some Scene {

#if os(macOS)

        // MARK: macOS

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
        .defaultSize(width: 1000, height: 800)
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

#else

        // MARK: tvOS and iPadOS

        WindowGroup {
            MainView()
                .environmentObject(kodi)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
        }
#endif
    }
}
