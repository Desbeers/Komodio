//
//  KomodioApp.swift
//  Shared
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftUI

import SwiftlyKodiAPI

/// The startpoint of Komodio
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    /// The Scene
    var body: some Scene {
        WindowGroup {
            RootView()
            .environmentObject(kodi)
            .ignoresSafeArea()
            .task {
                print("Scene task!")
                await kodi.connectToHost(kodiHost: HostItem(ip: "127.0.0.1"))
            }
        }
#if os(macOS)
        //.windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
