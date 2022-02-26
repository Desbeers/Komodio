//
//  KomodioApp.swift
//  Shared
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

/// The startpoint of Komodio
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    /// The Scene
    var body: some Scene {
        WindowGroup {
            Router {
                RootView()
            }
            .environmentObject(kodi)
            .ignoresSafeArea()
        }
#if os(macOS)
        //.windowToolbarStyle(.unifiedCompact(showsTitle: true))
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
