//
//  MainView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Main View

/// SwiftUI View for the main navigation (tvOS)
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject var scene: SceneState = .shared
    /// Bool if the sidebar has focus
    @FocusState var isFocused: Bool

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
        }
        .setBackground()
        .animation(.default, value: scene.sidebarSelection)
        .setSiriExit()
        /// Put the ``SidebarView`` into the `safe area`.
        .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
            SidebarView()
                .fixedSize()
                .frame(
                    width: isFocused ? KomodioApp.sidebarWidth : KomodioApp.sidebarCollapsedWidth,
                    alignment: .center
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.trailing)
                .opacity(isFocused ? 1 : 0.2)
                .background(.regularMaterial.opacity(isFocused ? 1 : 0.8))
                .focused($isFocused)
                .clipped()
                .ignoresSafeArea()
        }
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                isFocused = true
            }
        }
        .environmentObject(scene)
        .animation(.default, value: isFocused)
    }
}
