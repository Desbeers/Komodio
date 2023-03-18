//
//  SidebarView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the sidebar (macOS)
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
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
        /// Override de default list style that it set in ``MainView``
        .listStyle(.sidebar)
        .animation(.default, value: searchField)
        .animation(.default, value: kodi.status)
        .buttonStyle(.plain)
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
        label(title: "Komodio", description: kodi.status.message, icon: "sparkles.tv")
            .tag(Router.start)
        sidebarItem(item: Router.favourites)
        if !kodi.configuredHosts.isEmpty {
            Section("Your Kodi's") {
                ForEach(kodi.configuredHosts) { host in
                    Label(title: {
                        VStack(alignment: .leading) {
                            Text(host.name)
                            Text(host.isOnline ? "Online" : "Offline")
                                .font(.caption)
                                .opacity(0.6)
                                .padding(.bottom, 2)
                        }
                    }, icon: {
                        Image(systemName: "globe")
                            .foregroundColor(host.isOnline ? host.isSelected ? .green : .accentColor : .red)
                    })
                    .tag(Router.hostItemSettings(host: host))
                }
            }
        }
        if !kodi.bonjourHosts.filter({$0.new}).isEmpty {
            Section("New Kodi's") {
                ForEach(kodi.bonjourHosts.filter({$0.new}), id: \.ip) { host in
                    Label(title: {
                        Text(host.name)
                    }, icon: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    })
                    .tag(Router.hostItemSettings(host: HostItem(ip: host.ip, media: .video, player: .stream, status: .new)))
                }
            }
        }
        Section("Movies") {
            sidebarItem(item: Router.movies)
            sidebarItem(item: Router.unwatchedMovies)
            if !kodi.library.moviePlaylists.isEmpty {
                ForEach(kodi.library.moviePlaylists, id: \.file) { playlist in
                    sidebarItem(item: .moviesPlaylist(file: playlist))
                }
            }
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
            }
        }
        if kodi.status == .loadedLibrary || kodi.status == .outdatedLibrary {
            Section("Maintanance") {
                sidebarItem(item: Router.kodiSettings)
                Button(action: {
                    Task {
                        await KodiConnector.shared.loadLibrary(cache: false)
                    }
                }, label: {
                    label(title: "Reload Library",
                          description: "Reload '\(kodi.host.name)'",
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
