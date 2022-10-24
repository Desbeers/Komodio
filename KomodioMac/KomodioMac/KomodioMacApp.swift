//
//  KomodioMacApp.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI
import SwiftlyKodiPlayer

@main
struct KomodioMacApp: App {
    /// The AppState model
    @StateObject var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(kodi)
                .environmentObject(appState)
                .task {
                    kodi.connect(host: .init(ip: "192.168.11.200", media: .video))
                }
        }
        .windowToolbarStyle(.unifiedCompact)
        /// Open a Video Window
        WindowGroup("Player", for: VideoItem.self) { $item in
            /// Check if `item` isn't `nil`
            if let item = item {
                KodiPlayerView(item: item.video, resume: item.resume)
                    .withHostingWindow { window in
                        if let window = window?.windowController?.window {
                            window.setPosition(vertical: .center, horizontal: .center, padding: 0)
                        }
                    }
            }
        }
        .defaultSize(width: 1280, height: 720)
        .windowStyle(.hiddenTitleBar)
    }
}
