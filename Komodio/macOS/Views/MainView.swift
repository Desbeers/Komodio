//
//  MainView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Main View

/// SwiftUI View for the main navigation (macOS)
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject private var scene: SceneState = .shared
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// The opacity of the View
    @State private var opacity: Double = 0
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all


    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        HStack(spacing: 0) {
            NavigationSplitView(
                columnVisibility: $columnVisibility,
                sidebar: {
                    SidebarView(searchField: $searchField)
                        .navigationSplitViewColumnWidth(200)
                },
                detail: {
                    details
                })
            .background(Color.primary.opacity(0.1))
            DetailView()
                .frame(maxWidth: .infinity)
        }
        .setBackground()
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                scene.mainSelection = .start
            }
            opacity = 1
            state = .ready
        }
        .scrollContentBackground(.hidden)
        .animation(.default, value: scene.mainSelection)
        .searchable(text: $searchField, prompt: "Search library")
        .task(id: searchField) {
            await scene.updateSearch(query: searchField)
        }
        .environmentObject(scene)
    }

    // MARK: Content of the Details

    /// The body of the View
    var details: some View {
        VStack {
            switch state {
            case .ready:
                NavigationStack(path: $scene.navigationStackPath) {
                    ContentView()
                        .navigationSubtitle(scene.mainSelection.item.description)
                }
            default:
                PartsView.StatusMessage(router: scene.mainSelection, status: state)
            }
        }
        .navigationSplitViewColumnWidth(KomodioApp.columnWidth)
        .navigationStackAnimation(opacity: $opacity)
    }
}
