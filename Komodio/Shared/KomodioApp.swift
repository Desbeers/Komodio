//
//  KomodioApp.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Komodio App

/// The Komodio App Scene (shared)
@main struct KomodioApp: App {
    /// The SceneState model
    @State private var scene: SceneState = SceneState()
    /// The KodiConnector model
    @State private var kodi: KodiConnector = .shared

    // MARK: Body of the Scene

    /// The body of the Scene
    var body: some Scene {

#if os(macOS)

        // MARK: macOS

        Window("Komodio", id: "Main") {
            MainView()
                .environment(scene)
                .environment(kodi)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: NSWindow.didEnterFullScreenNotification,
                    object: nil)
                ) { _ in
                    scene.fullScreen = true
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: NSWindow.willExitFullScreenNotification,
                    object: nil)
                ) { _ in
                    scene.fullScreen = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                /// Hide the "New Player" window option
            }
            CommandGroup(replacing: .appSettings) {
                Button("Settings…") {
                    scene.navigationStack.append(.appSettings)
                }
            }
            AboutPanelCommand(
                title: "About Komodio",
                credits: "A video client for Kodi"
            )
            GithubHelpCommand(
                url: "https://github.com/Desbeers/Komodio",
                replace: true
            )
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1000, height: 800)

        /// Open a Video Window
        WindowGroup("Player", for: MediaItem.self) { $media in
            /// Check if `media` isn't `nil` and that we have a Kodi item
            if let media {
                KomodioPlayerView(media: media)
                    .navigationTitle(media.title)
            }
        }
        .defaultSize(width: 1280, height: 720)
        .defaultPosition(.center)
        .windowStyle(.hiddenTitleBar)

#elseif os(visionOS)

        // MARK: visionOS

        WindowGroup {
            MainView()
                .environment(scene)
                .environment(kodi)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
        }

        /// Open a Video Window
        WindowGroup("Player", for: MediaItem.self) { $media in
            /// Check if `media` isn't `nil` and that we have a Kodi item
            if let media {
                KomodioPlayerView(media: media)
                    .navigationTitle(media.title)
            }
        }

        /// Immersive View
        ImmersiveSpace(id: "Fanart", for: MediaItem.self ) { $media in
            /// Check if media isn't `nil` and that we have a Kodi item
            if let media {
                ImmersiveView(media: media)
            }
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)

#else

        // MARK: tvOS and iPadOS

        WindowGroup {
            MainView()
                .environment(scene)
                .environment(kodi)
                .task {
                    if kodi.status == .none {
                        /// Get the selected host (if any)
                        kodi.getSelectedHost()
                    }
                }
            #if os(iOS)
                .statusBar(hidden: true)
            #endif
        }
#endif
    }
}
