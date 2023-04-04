//
//  KomodioApp.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Komodio App

/// The Komodio App Scene (tvOS)
@main struct KomodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector = .shared
    /// The SceneState model
    @StateObject var scene: SceneState = .shared

    // MARK: Body of the Scene

    /// The body of the Scene
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
                        Color("BlendColor")
                        if let background = scene.selectedKodiItem, !background.fanart.isEmpty {
                            KodiArt.Fanart(item: background)
                                .grayscale(1)
                                .opacity(0.2)
                                .scaledToFill()
                                .transition(.opacity)
                        } else {
                            Image("Background")
                                .resizable()
                                .opacity(0.2)
                                .scaledToFill()
                                .transition(.opacity)
                        }
                    }
                        .ignoresSafeArea()
                )
                .animation(.default, value: scene.navigationStackPath)
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

    /// The default corner radius
    static let cornerRadius: Double = 10

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 260))]
}
