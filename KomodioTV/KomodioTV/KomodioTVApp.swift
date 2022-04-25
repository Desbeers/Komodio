//
//  KomodioTVApp.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

@main
struct KomodioTVApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    var body: some Scene {
        WindowGroup {
            Group {
                if kodi.loadingState == .done {
                    //NavigationView {
                        ContentView()
                            .environmentObject(kodi)
                    //}
                } else {
                    Text("Loading...")
                }
            }
            .task {
                if kodi.loadingState == .start {
                    await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200"))
                    //await kodi.connectToHost(kodiHost: HostItem(ip: "127.0.0.1"))
                }
            }
        }
    }
}