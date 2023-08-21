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
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .scrollContentBackground(.hidden)
            .searchable(text: $searchField, prompt: "Search library")
            .task(id: searchField) {
                await scene.updateSearch(query: searchField)
            }
            .onChange(of: scene.mainSelection) { selection in
                Task { @MainActor in
                    scene.detailSelection = selection
                }
            }
            .onChange(of: scene.navigationStack) { item in
                Task { @MainActor in
                    scene.detailSelection = (item.isEmpty ? scene.mainSelection : item.last) ?? scene.mainSelection
                }
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
                    .navigationSplitViewColumnWidth(StaticSetting.sidebarWidth)
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
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Buttons.CollectionStyle(hide: false)
            }
        }
#endif

#if os(iOS) || os(visionOS)
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .navigationSplitViewColumnWidth(StaticSetting.sidebarWidth)
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
        NavigationStack(path: $scene.navigationStack.animation(.easeInOut)) {
            ContentView()
                .navigationSubtitle(scene.mainSelection.item.description)
        }
        .navigationSplitViewColumnWidth(
            min: StaticSetting.contentWidth,
            ideal: StaticSetting.contentWidth,
            max: StaticSetting.contentWidth * 2
        )
#endif

#if os(iOS) || os(visionOS)
        NavigationStack(path: $scene.navigationStack) {
            ContentView()
                .navigationTitle(scene.mainSelection.item.description)
                .navigationBarTitleDisplayMode(.inline)
                .setBackground()
        }
#endif
    }
}
