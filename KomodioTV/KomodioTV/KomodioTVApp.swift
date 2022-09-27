//
//  KomodioTVApp.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

@main
struct KomodioTVApp: App {
    /// The AppState model
    @StateObject var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(kodi)
                .environmentObject(appState)
            .task(id: appState.host) {
                if let host = appState.host {
                    if kodi.state == .none {
                        print("Load new host")
                        kodi.connect(host: host)
                    }
                }
            }
            .task(id: kodi.state) {
                switch kodi.state {
                case .offline, .loadedLibrary:
                    appState.selectedTab = .home
                default:
                    break
                }
            }
        }
    }
}
