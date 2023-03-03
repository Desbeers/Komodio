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
    @StateObject private var scene: SceneState = .shared
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
                        PartsView.GradientOverlay()
                    }
            }
        )
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                scene.sidebarSelection = .start
            }
        }
        /// The list style is the same in every View so set it here
        /// - Note: Not for the ``SidebarView`` but it will override it
        .listStyle(.inset(alternatesRowBackgrounds: true))
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
