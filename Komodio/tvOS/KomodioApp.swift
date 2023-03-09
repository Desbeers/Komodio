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
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The SceneState model
    @StateObject var scene: SceneState = .shared
    /// The body of the scene
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
                .background(
                    ZStack {
                        if let background = scene.background {
                            KodiArt.Fanart(item: background)
                                .opacity(background.media == .movie ? 1 : 0.2)
                                .overlay {
                                    PartsView.GradientOverlay()
                                        .opacity(0.3)
                                }
                        } else {
                            Image("Background")
                                .resizable()
                                .opacity(0.3)
                                .overlay {
                                    PartsView.GradientOverlay()
                                }
                        }
                    }
                        .scaledToFill()
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .id(scene.background?.id)
                        .animation(.default, value: scene.background?.id)
                )
        }
    }
}

extension KomodioApp {

    // MARK: Static settings

    /// The plaform
    static let platform: Parts.Platform = .tvOS

    /// The default size of poster art
    static let posterSize = CGSize(width: 240, height: 360)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// The width of the sidebar
    static let sidebarWidth: Double = 450

    /// The width of the sidebar when collapsed
    static var sidebarCollapsedWidth: Double {
        KomodioApp.sidebarWidth / 3
    }
}
