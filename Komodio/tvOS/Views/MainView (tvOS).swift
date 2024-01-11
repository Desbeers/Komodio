//
//  MainView.swift
//  Komodio (tvOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Main View

/// SwiftUI `View` for the main navigation (tvOS)
struct MainView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @State private var scene: SceneState = SceneState()
    /// Bool if the sidebar has focus
    @FocusState var isFocused: Bool

    @FocusState var displayIsFocused: Bool

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        @Bindable var scene = scene
        NavigationStack(path: $scene.navigationStack) {
            ContentView()
        }
        .setSiriExit()
        /// Put the ``SidebarView`` into the `safe area`.
        .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
            SidebarView()
                .fixedSize()
                .frame(
                    width: isFocused ? StaticSetting.sidebarWidth : StaticSetting.sidebarCollapsedWidth,
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
        .setBackground()
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                isFocused = true
            }
        }
        .environment(scene)
        .animation(.default, value: isFocused)
    }
}
