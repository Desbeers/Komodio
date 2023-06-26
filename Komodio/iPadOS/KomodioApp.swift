//
//  KomodioPadApp.swift
//  KomodioPad
//
//  Created by Nick Berendsen on 23/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The SceneState model
    @StateObject var scene: SceneState = .shared
    /// The body of the `Scene`
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(kodi)
                .environmentObject(scene)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
        }
    }
}

extension KomodioApp {

    // MARK: Static settings

    /// The plaform
    static let platform: Parts.Platform = .iPadOS

    /// The default size of poster art
    static let posterSize = CGSize(width: 180, height: 270)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// The default corner radius
    static let cornerRadius: Double = 8

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 200))]
}
