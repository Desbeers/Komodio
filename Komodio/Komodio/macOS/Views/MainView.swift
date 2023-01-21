//
//  MainView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation (macOS)
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject private var scene = SceneState()
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
            },
            content: {
                ContentView()
                    .navigationSplitViewColumnWidth(ContentView.columnWidth)
                    .frame(maxHeight: .infinity, alignment: .top)
            },
            detail: {
                DetailView()
            })
        .background(
            ZStack {
                Color(nsColor: .controlBackgroundColor)
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .overlay {
                        Parts.GradientOverlay()
                    }
            }
        )
        .task(id: kodi.state) {
            if kodi.state != .loadedLibrary {
                scene.sidebarSelection = .start
            }
        }
        .navigationSubtitle(scene.navigationSubtitle)
        .animation(.default, value: scene.sidebarSelection)
        .animation(.default, value: scene.contentSelection)
        .searchable(text: $searchField, prompt: "Search library")
        .task(id: searchField) {
            await scene.updateSearch(query: searchField)
        }
        .environmentObject(scene)
    }
}
