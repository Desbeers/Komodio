//
//  SidebarView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    var body: some View {
        List(selection: $scene.sidebar) {
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
            Section("Maintanance") {
                Button(action: {
                    Task {
                        await KodiConnector.shared.loadLibrary(cache: false)
                    }
                }, label: {
                    Text("Reload library")
                })
                .disabled(kodi.state != .loadedLibrary)
            }
        }
        .onChange(of: scene.sidebar) { _ in
            /// Reset the selection
            scene.selection = SceneState.Selection(route: scene.sidebar)
        }
    }
    
    @ViewBuilder func sidebarItem(item: Router) -> some View {
            Label(item.label.title, systemImage: item.label.icon)
                .tag(item)
    }
}
