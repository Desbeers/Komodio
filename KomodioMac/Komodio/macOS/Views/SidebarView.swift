//
//  SidebarView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the sidebar
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The selected host
    @State private var selectedHost: String?
    /// The body of the View
    var body: some View {
        VStack {
            List(selection: $scene.sidebarSelection) {
                content
            }
            .onChange(of: scene.sidebarSelection) { selection in
                /// Reset the details
                scene.details = selection
                /// Set the contentSelection
                scene.contentSelection = selection
            }
        }
        .animation(.default, value: scene.query)
        .buttonStyle(.plain)
    }

    @ViewBuilder var content: some View {
        Section("Your Kodi's") {
            ForEach(kodi.bonjourHosts, id: \.ip) { host in
                Button(action: {
                    if AppState.shared.host?.ip != host.ip {
                        var values = HostItem()
                        values.ip = host.ip
                        AppState.saveHost(host: values)
                    }
                }, label: {
                    Label(title: {
                        Text(host.name)
                    }, icon: {
                        Image(systemName: "globe")
                            .foregroundColor(AppState.shared.host?.ip == host.ip ? .green : .gray)
                    })
                })
            }
        }
        Section("Movies") {
            sidebarItem(item: Router.movies)
            sidebarItem(item: Router.unwatchedMovies)
        }
        Section("TV shows") {
            sidebarItem(item: Router.tvshows)
            sidebarItem(item: Router.unwachedEpisodes)
        }
        Section("Music Videos") {
            sidebarItem(item: Router.musicVideos)
        }
        if !scene.query.isEmpty {
            Section("Search") {
                sidebarItem(item: Router.search)
            }
        }
        Section("Maintanance") {
            sidebarItem(item: Router.kodiSettings)
                .disabled(kodi.state != .loadedLibrary)
            Button(action: {
                Task {
                    scene.sidebarSelection = .start
                    scene.navigationSubtitle = ""
                    await KodiConnector.shared.loadLibrary(cache: false)
                }
            }, label: {
                Label("Reload Library", systemImage: "arrow.triangle.2.circlepath")
            })
            .disabled(kodi.state != .loadedLibrary)
        }
        .tint(.orange)
    }

    @ViewBuilder func sidebarItem(item: Router) -> some View {
        Label(item.label.title, systemImage: item.label.icon)
            .tag(item)
    }
}
