//
//  MainView.swift
//  KomodioPad
//
//  Created by Nick Berendsen on 23/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {

    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject var scene: SceneState = .shared
    /// The search field in the toolbar
    @State private var searchField: String = ""

    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView(searchField: $searchField)
                    .navigationTitle("Komodio")
            },
            detail: {
                NavigationStack(path: $scene.navigationStackPath) {
                    ContentView()
                        .navigationTitle(scene.mainSelection.item.description)
                        .navigationBarTitleDisplayMode(.inline)
                        .animation(.default, value: scene.mainSelection)
                        .setBackground()
                }
            }
        )
        .scrollContentBackground(.hidden)
        .searchable(text: $searchField, prompt: "Search library")
        .task(id: searchField) {
            await scene.updateSearch(query: searchField)
        }
        .environmentObject(scene)
        .animation(.default, value: scene.navigationStackPath)
    }
}
