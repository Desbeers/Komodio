//
//  ContentView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Content View

/// SwiftUI `View` for the main content (shared)
struct ContentView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        Router.DestinationView(router: scene.mainSelection)
            .navigationDestination(for: Router.self) { router in
                Router.DestinationView(router: router)
                    .appendPlatformStuff(router: router)
                    .opacity(scene.navigationStack.last == router ? 1 : 0)
            }
#if os(macOS)
            .opacity(scene.navigationStack.isEmpty ? 1 : 0)
#endif
    }
}
