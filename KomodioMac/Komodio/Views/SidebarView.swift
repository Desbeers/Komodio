//
//  SidebarView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    var body: some View {
        List(selection: $scene.selection) {
            Section("Your Kodio's") {
                ForEach(kodi.bonjourHosts, id: \.ip) { host in
                    Button(action: {
                        var values = HostItem()
                        values.description = host.name
                        values.ip = host.ip
                        AppState.saveHost(host: values)
                    }, label: {
                        Label(title: {
                            Text(host.name)
                        }, icon: {
                            Image(systemName: "globe")
                                .opacity(0.5)
                        })
                        .foregroundColor(AppState.shared.host?.ip == host.ip ? .black : .gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    })
                    .disabled(AppState.shared.host?.ip == host.ip)
                }
                .buttonStyle(.plain)
            }
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
