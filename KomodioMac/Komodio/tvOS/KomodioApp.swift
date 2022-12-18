//
//  KomodioApp.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 02/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// The Komodio App Scene
@main struct KomodioApp: App {
    /// The AppState model
    @StateObject var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The body of the scene
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(kodi)
                .environmentObject(appState)
                .task(id: appState.host) {
                    if let host = appState.host {
                        if kodi.state == .none {
                            kodi.connect(host: host)
                        }
                    }
                }
        }
    }
}
