//
//  MainView.swift
//  Komodio (macOS +iOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Main View

/// SwiftUI `View` for the main navigation (macOS +iOS)
/// - Note: tvOS has its own `View`
struct MainView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .scrollContentBackground(.hidden)
            .task(id: searchField) {
                await scene.updateSearch(query: searchField)
            }
            .onChange(of: scene.mainSelection) {
                scene.detailSelection = scene.mainSelection
            }
            .onChange(of: scene.navigationStack) {
                scene.detailSelection =
                (scene.navigationStack.isEmpty ? scene.mainSelection : scene.navigationStack.last)
                ?? scene.mainSelection
            }
            .searchable(text: $searchField, placement: .sidebar, prompt: "Search library")
            .setBackground()
            .environment(scene)
    }

    // MARK: MARK: Content of the View

    /// The `NavigationSplitView`
    @ViewBuilder var content: some View {
        @Bindable var scene2 = scene
#if os(macOS)
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .background(.blend.gradient.opacity(0.6))
            },
            detail: {
                details
                    .navigationBarBackButtonHidden(true)
            }
        )
        .inspector(isPresented: $scene2.showInspector) {
            DetailView()
                .inspectorColumnWidth(min: 500, ideal: 800, max: 1200)
                .background(.blend.gradient)
                .fullScreenSafeArea()
        }
        .frame(maxWidth: .infinity)
        .toolbar {
            Buttons.BackButton()
        }
        .task(id: scene.detailSelection) {
            switch scene.detailSelection {
            case .start:
                scene.showInspector = false
            default:
                scene.showInspector = true
            }
        }
#endif

#if os(iOS) || os(visionOS)
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .background(.blend.gradient)
                    .navigationSplitViewColumnWidth(StaticSetting.sidebarWidth)
            },
            detail: {
                details
                    .toolbar(.hidden)
                    .ignoresSafeArea()
            }
        )
#endif
    }

    // MARK: Details of the NavigationSplitView

    /// The details of the `NavigationSplitView`
    @ViewBuilder var details: some View {
        @Bindable var scene = scene

#if os(macOS)
        NavigationStack(path: $scene.navigationStack) {
            ContentView()
                .navigationSubtitle(scene.mainSelection.item.description)
        }
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
