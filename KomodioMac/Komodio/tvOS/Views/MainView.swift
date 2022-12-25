//
//  MainView.swift
//  KomodioTV (tvOS)
//
//  Created by Nick Berendsen on 02/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject var scene = SceneState()
    /// Bool if the sidebar has focus
    @FocusState var isFocused: Bool
    /// The color scheme
    @Environment(\.colorScheme) var colorScheme
    /// The body of the View
    var body: some View {
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
            /// Set the destinations for sub-views
        }
        /// Put the ``SidebarView`` into the `safe area`.
        .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
            SidebarView()
                .fixedSize()
                .frame(width: isFocused ? KomodioApp.sidebarWidth : KomodioApp.sidebarCollapsedWidth, alignment: .center)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.trailing)
                .opacity(isFocused ? 1 : 0.2)
                .background(.regularMaterial)
                .focused($isFocused)
                .clipped()
                .ignoresSafeArea()
        }
        /// Show details in a `FullScreenCover`
        .fullScreenCover(isPresented: $scene.showDetails) {
            ZStack {
                Color(colorScheme == .light ? .white : .black)
                DetailView()
            }
            .ignoresSafeArea()
        }
        .animation(.default, value: isFocused)
        .animation(.default, value: scene.sidebarSelection)
        .environmentObject(scene)
    }
}
