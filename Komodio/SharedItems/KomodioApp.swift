//
//  KomodioApp.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The startpoint of Komodio
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    /// The AppState model
    @StateObject var appState: AppState  = .shared
    /// The Scene
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: 800, minHeight: 600)
            .environmentObject(kodi)
            .ignoresSafeArea()
            .task {
                if kodi.loadingState == .start {
                    await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200"))
                }
            }
        }
#if os(macOS)
        //.windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowStyle(.hiddenTitleBar)
        .commands {
            SidebarCommands()
        }
#endif
    }
}
