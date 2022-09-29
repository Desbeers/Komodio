//
//  KomodioTVApp.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The App struct for KomodioTV
@main struct KomodioTVApp: App {
    /// The AppState model
    @StateObject var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The files Komodio can play
    static let fileExtension: [String] = ["caf", "ttml", "au", "ts", "mqv", "pls", "flac", "dv", "amr", "mp1", "mp3", "ac3", "loas", "3gp", "aifc", "m2v", "m2t", "m4b", "m2a", "m4r", "aa", "webvtt", "aiff", "m4a", "scc", "mp4", "m4p", "mp2", "eac3", "mpa", "vob", "scc", "aax", "mpg", "wav", "mov", "itt", "xhe", "m3u", "mts", "mod", "vtt", "m4v", "3g2", "sc2", "aac", "mp4", "vtt", "m1a", "mp2", "avi"]
    /// The body of this App
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
