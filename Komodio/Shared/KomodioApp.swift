//
//  KomodioApp.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
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

#if os(macOS)
    /// AppKit app delegate
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
#endif

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
        .defaultSize(width: 1920, height: 1080)

        /// Open a Video Window
        WindowGroup("Player", for: MediaItem.self) { $media in
            /// Check if `media` isn't `nil` and that we have a Kodi item
            if let media {
                KomodioPlayerView(media: media)
                    .navigationTitle(media.title)
            }
        }
        // .windowStyle(.volumetric)

        ImmersiveSpace(id: "Fanart", for: MediaItem.self ) { $media in
            /// Check if media isn't `nil` and that we have a Kodi item
            if let media {
                ImmersiveView(media: media)
            }
        }
        // .immersionStyle(selection: .constant(.mixed), in: .mixed)
        // .immersionStyle(selection: .constant(.full), in: .full)
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
