//
//  MainView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {
    
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @StateObject var scene = SceneState()
    
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                SidebarView()
            },
            content: {
                ContentView()
                    .navigationSplitViewColumnWidth(400)
            },
            detail: {
                DetailsView()
            })
        .environmentObject(scene)
    }
}
