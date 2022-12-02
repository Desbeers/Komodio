//
//  MainView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation
struct MainView: View {
    /// The SceneState model
    @StateObject var scene = SceneState()
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    /// The body of the view
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView()
            },
            content: {
                ContentView()
                    .navigationSplitViewColumnWidth(ContentView.columnWidth)
            },
            detail: {
                DetailView()
            })
        .navigationSubtitle(scene.navigationSubtitle)
        .environmentObject(scene)
    }
}
