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
    /// The search field in the toolbar
    @State private var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        HStack {
            NavigationSplitView(
                columnVisibility: $columnVisibility,
                sidebar: {
                    SidebarView(searchField: $searchField)
                        .navigationSplitViewColumnWidth(200)
                },
                detail: {
                    ContentView()
                        .navigationSplitViewColumnWidth(ContentView.columnWidth)
                })
            .background(Color.primary.opacity(0.1))
            DetailView()
                .frame(maxWidth: .infinity)
        }
        .background(
            ZStack {
                Color("BlendColor")
                if let item = scene.selectedKodiItem, !item.fanart.isEmpty {
                    KodiArt.Fanart(item: item)
                        .grayscale(1)
                        .opacity(0.1)
                        .scaledToFill()
                        .transition(.opacity)
                } else {
                    Image("Background")
                        .resizable()
                        .opacity(0.1)
                        .scaledToFill()
                        .transition(.opacity)
                }
            }
                .animation(.default, value: scene.selectedKodiItem?.id)
        )
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                scene.sidebarSelection = .start
            }
        }
        .scrollContentBackground(.hidden)
        .navigationSubtitle(scene.navigationSubtitle)
        .animation(.default, value: scene.sidebarSelection)
        .searchable(text: $searchField, prompt: "Search library")
        .task(id: searchField) {
            await scene.updateSearch(query: searchField)
        }
        .environmentObject(scene)
    }
}
