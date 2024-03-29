//
//  SidebarView.swift
//  Komodio (macOS +iOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Sidebar View

/// SwiftUI `View` for the sidebar (macOS + iOS)
/// - Note: tvOS has its own `View`
struct SidebarView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The search query
    /// - Note: This is here to show or hide the 'search' menu item
    @Binding var searchField: String
    /// The current selection in the ``SidebarView``
    @State private var sidebarSelection: Router? = .start

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            List(selection: $sidebarSelection) {
                content
            }
            .onChange(of: sidebarSelection) { _, selection in
                if let selection {
                    scene.navigationStack = []
                    scene.mainSelection = selection
                }
            }
            .onChange(of: scene.mainSelection) { _, selection in
                if selection != sidebarSelection {
                    sidebarSelection = selection
                }
            }
        }
        /// Override de default list style that it set in ``MainView``
        .listStyle(.sidebar)
        .animation(.default, value: searchField)
        .animation(.default, value: kodi.status)
        .buttonStyle(.plain)
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {
        Label(title: {
            VStack(alignment: .leading) {
                Text(kodi.host.name)
                Text(kodi.status.message)
                    .font(.caption)
                    .opacity(0.5)
            }
        }, icon: {
            Image(systemName: "globe")
        })
        .listItemTint(kodi.hostIsOnline(kodi.host) ? .green : .red)
        .tag(Router.start)
        if kodi.status == .loadedLibrary {
            sidebarItem(router: Router.favourites)
                .listItemTint(.red)
            Section("Movies") {
                sidebarItem(router: Router.movies)
                sidebarItem(router: Router.unwatchedMovies)
                if !kodi.library.moviePlaylists.isEmpty {
                    ForEach(kodi.library.moviePlaylists, id: \.file) { playlist in
                        sidebarItem(router: .moviePlaylist(file: playlist))
                    }
                }
            }
            Section("TV shows") {
                sidebarItem(router: Router.tvshows)
                sidebarItem(router: Router.unwachedEpisodes)
            }
            Section("Music Videos") {
                sidebarItem(router: Router.musicVideos)
            }
            if !searchField.isEmpty {
                Section("Search") {
                    sidebarItem(router: Router.search)
                }
            }
        }
    }

    /// SwiftUI `View` for an item in the sidebar
    /// - Parameter router: The ``Router`` item
    /// - Returns: A SwiftUI `View` with the sidebar item
    private func sidebarItem(router: Router) -> some View {

        Label(title: {
            VStack(alignment: .leading) {
                Text(router.item.title)
                Text(router.item.description)
                    .font(.caption)
                    .opacity(0.5)
            }
        }, icon: {
            Image(systemName: router.item.icon)
        })
        .tag(router)
        .listItemTint(router.item.color)
    }
}
