//
//  KomodioApp.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The Komodio App Scene (tvOS)
@main struct KomodioApp: App {
    /// The AppState model
    @StateObject var appState: AppState = .shared
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The SceneState model
    @StateObject var scene = SceneState()
    /// The body of the scene
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(kodi)
                .environmentObject(appState)
                .environmentObject(scene)
                .task(id: appState.host) {
                    if let host = appState.host {
                        if kodi.state == .none {
                            kodi.connect(host: host)
                        }
                    }
                }
                .background(
                    ZStack {
                        if let background = scene.background {
                            KodiArt.Art(file: background)
                                .opacity(0.2)
                                .overlay {
                                    Parts.GradientOverlay()
                                        .opacity(0.3)
                                }
                        } else {
                            Image("Background")
                                .resizable()
                                .opacity(0.3)
                                .overlay {
                                    Parts.GradientOverlay()
                                }
                        }
                    }
                        .scaledToFill()
                        .ignoresSafeArea()
                        .transition(.slide)
                )
                .animation(.default, value: scene.background)
        }
    }
}

extension KomodioApp {

    // MARK: Static settings

    /// The default size of poster art
    static let posterSize = CGSize(width: 240, height: 360)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The width of the sidebar
    static let sidebarWidth: Double = 450

    /// The width of the sidebar when collapsed
    static var sidebarCollapsedWidth: Double {
        KomodioApp.sidebarWidth / 3
    }
}
