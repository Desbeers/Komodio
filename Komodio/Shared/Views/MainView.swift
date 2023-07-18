//
//  MainView.swift
//  Komodio (macOS +iOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Main View

/// SwiftUI `View` for the main navigation (macOS +iOS)
/// - Note: tvOS has its own `View`
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject private var scene: SceneState = .shared
    /// The opacity of the View
    @State private var opacity: Double = 1
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .scrollContentBackground(.hidden)
            .animation(.default, value: scene.mainSelection)
            .searchable(text: $searchField, prompt: "Search library")
            .task(id: searchField) {
                await scene.updateSearch(query: searchField)
            }
            .environmentObject(scene)
    }

    // MARK: MARK: Content of the View

    /// The `NavigationSplitView`
    @ViewBuilder var content: some View {
#if os(macOS)
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .navigationSplitViewColumnWidth(KomodioApp.platform == .macOS ? 200 : 250)
            },
            content: {
                details
            },
            detail: {
                DetailView()
                    .frame(maxWidth: .infinity)
            })
        .background(Color.primary.opacity(0.1))
        .setBackground()
#endif

#if os(iOS)
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .navigationSplitViewColumnWidth(KomodioApp.platform == .macOS ? 200 : 250)
            },
            detail: {
                details
            })
        .background(Color.primary.opacity(0.1))
#endif
    }

    // MARK: Details of the NavigationSplitView

    /// The details of the `NavigationSplitView`
    @ViewBuilder var details: some View {
#if os(macOS)
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
                .navigationSubtitle(scene.mainSelection.item.description)
        }
        .navigationSplitViewColumnWidth(KomodioApp.columnWidth)
        .navigationStackAnimation(opacity: $opacity)
#endif

#if os(iOS)
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
                .navigationTitle(scene.mainSelection.item.description)
                .navigationBarTitleDisplayMode(.inline)
                .setBackground()
        }
#endif
    }
}
