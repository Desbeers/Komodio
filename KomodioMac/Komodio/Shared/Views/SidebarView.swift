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
    /// The focus state
    @FocusState var focusState: Router?

    @FocusState var isFocused: Bool

    /// The body of the view
    var body: some View {
        VStack {
#if os(macOS)
            List(selection: $scene.sidebarSelection) {
                content
            }
#elseif os(tvOS)
            List {
                content
            }
            .focused($isFocused)
            .task(id: isFocused) {
                /// Restore the last selection
                if isFocused, focusState != scene.sidebarSelection {
                    focusState = scene.sidebarSelection
                }
            }
#endif
        }
        .onChange(of: scene.sidebarSelection) { selection in
            /// Reset the details
            scene.details = selection
            /// Set the contentSelection
            scene.contentSelection = selection
        }
        .animation(.default, value: scene.query)
        .buttonStyle(.plain)
    }

    @ViewBuilder var content: some View {
        Section("Your Kodio's") {
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
                            //.font(.title3)
                    })
                    //.tint(AppState.shared.host?.ip == host.ip ? .green : .gray)
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

#if os(macOS)
    @ViewBuilder func sidebarItem(item: Router) -> some View {
        Label(item.label.title, systemImage: item.label.icon)
            //.focused($focusState, equals: item)
            .tag(item)
    }
#elseif os(tvOS)
    @ViewBuilder func sidebarItem(item: Router) -> some View {
        Button(action: {
            scene.sidebarSelection = item
        }, label: {
            Label(title: {
                VStack(alignment: .leading) {
                    Text(item.label.title)
                    Text(item.label.description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }, icon: {
                Image(systemName: item.label.icon)
                    .foregroundColor(scene.sidebarSelection == item ? .blue : .gray)
            })
        })
        .focused($focusState, equals: item)
    }
#endif
}
