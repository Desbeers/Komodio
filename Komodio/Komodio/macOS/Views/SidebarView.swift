//
//  SidebarView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the sidebar  (macOS)
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The AppState model
    @EnvironmentObject private var appState: AppState
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The search query
    /// - Note: This is here to show or hide the 'search' menu item
    @Binding var searchField: String

    // MARK: Body of the View

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
        .animation(.default, value: searchField)
        .animation(.default, value: kodi.state)
        .buttonStyle(.plain)
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
        label(title: "Komodio", description: kodi.state.rawValue, icon: "sparkles.tv")
            .tag(Router.start)
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
        if !searchField.isEmpty {
            Section("Search") {
                sidebarItem(item: Router.search)
            }        }
        if kodi.state == .loadedLibrary {
            Section("Maintanance") {
                sidebarItem(item: Router.kodiSettings)
                Button(action: {
                    Task {
                        scene.sidebarSelection = .start
                        scene.navigationSubtitle = ""
                        await KodiConnector.shared.loadLibrary(cache: false)
                    }
                }, label: {
                    label(title: "Reload Library",
                          description: "Reload '\(appState.host?.description ?? "")'",
                          icon: "arrow.triangle.2.circlepath"
                    )
                })
            }
            .tint(.orange)
        }
    }

    /// SwiftUI View for an item in the sidebar
    /// - Parameter item: The ``Router`` item
    /// - Returns: A SwiftUI View with the sidebar item
    private func sidebarItem(item: Router) -> some View {
        label(title: item.label.title, description: item.label.description, icon: item.label.icon)
        .tag(item)
    }

    /// SwiftUI View for a `Label` of a `Button` in the sidebar
    /// - Parameters:
    ///   - title: The title of the label
    ///   - description: The description of the label
    ///   - icon: The SF icon
    /// - Returns: A SwiftUI `Label` View
    private func label(title: String, description: String, icon: String) -> some View {
        Label(
            title: {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(description)
                        .font(.caption)
                        .opacity(0.6)
                        .padding(.bottom, 2)
                }
            }, icon: {
                Image(systemName: icon)
            })
    }
}
