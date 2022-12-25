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

extension KomodioApp {

    // MARK: Static settings

    /// The default size of poster art
    static let posterSize = CGSize(width: 240, height: 360)

    /// The width of the sidebar
    static let sidebarWidth: Double = 450

    /// The width of the sidebar when collapsed
    static var sidebarCollapsedWidth: Double {
        KomodioApp.sidebarWidth / 3
    }
}
