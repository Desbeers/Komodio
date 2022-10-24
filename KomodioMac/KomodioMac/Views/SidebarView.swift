//
//  SidebarView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI

struct SidebarView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    var body: some View {
        List(selection: $scene.selection) {
            Section("Videos") {
                sidebarItem(item: Router.movies)
                sidebarItem(item: Router.tvshows)
                sidebarItem(item: Router.musicVideos)
            }
        }
        .onChange(of: scene.selection) { _ in
            /// Make sure there are no TV shows selected
            scene.selectedTVShow = nil
        }
    }
    
    @ViewBuilder func sidebarItem(item: Router) -> some View {
            Label(item.sidebar.title, systemImage: item.sidebar.icon)
                .tag(item)
    }
}
