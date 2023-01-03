//
//  MainView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation
struct MainView: View {
    /// The SceneState model
    @StateObject var scene = SceneState()
    /// The search field in the toolbar
    @State var searchField: String = ""
    /// Set the column visibility
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
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
                    .background(
                        Image("fanart")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.1)
                    )
            },
            detail: {
                DetailView()
            })
        .background(VisualEffect())
        .navigationSubtitle(scene.navigationSubtitle)
        .animation(.default, value: scene.sidebarSelection)
        .searchable(text: $searchField, prompt: "Search library")
        .task(id: searchField) {
            await scene.updateSearch(query: searchField)
        }
        .environmentObject(scene)
    }
}

/// Transluent background
struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView { return NSVisualEffectView() }
    func updateNSView(_ nsView: NSView, context: Context) { }
}
