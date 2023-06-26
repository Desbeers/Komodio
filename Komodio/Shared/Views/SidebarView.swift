//
//  SidebarView.swift
//  Komodio (macOS +iOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Sidebar View

/// SwiftUI View for the sidebar (macOS + iOS)
/// - Note: tvOS has its own `View`
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The search query
    /// - Note: This is here to show or hide the 'search' menu item
    @Binding var searchField: String

    /// The current selection in the ``SidebarView``
    @State var sidebarSelection: Router? = .start

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            List(selection: $sidebarSelection) {
                content
            }
            .onChange(of: sidebarSelection) { selection in
                if let selection {
                    Task { @MainActor in
                        scene.sidebarSelection = selection
                        /// Reset the details
                        scene.details = selection
                        /// Reset the optional selected kodi item
                        scene.selectedKodiItem = nil
                        /// Set the navigation title
                        scene.navigationTitle = selection.label.description
                    }
                }
            }
            .onChange(of: scene.sidebarSelection) { selection in
                if selection != sidebarSelection {
                    Task { @MainActor in
                        sidebarSelection = selection
                    }
                }
            }
        }
        /// Override de default list style that it set in ``MainView``
        .listStyle(.sidebar)
        // .animation(.default, value: searchField)
        .animation(.default, value: kodi.status)
        .buttonStyle(.plain)
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {
        NavigationLink(value: Router.start) {
            Label(title: {
                VStack(alignment: .leading) {
                    Text(kodi.host.bonjour?.name ?? "Kodio")
                    Text(kodi.status.message)
                        .font(.caption)
                        .opacity(0.5)
                }
            }, icon: {
                Image(systemName: "globe")
            })
        }
        .listItemTint(kodi.host.isOnline ? .green : .red)
        if kodi.status == .loadedLibrary {
            sidebarItem(item: Router.favourites)
                .listItemTint(.red)
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
        }
    }

    /// SwiftUI View for an item in the sidebar
    /// - Parameter item: The ``Router`` item
    /// - Returns: A SwiftUI View with the sidebar item
    private func sidebarItem(item: Router) -> some View {
        NavigationLink(value: item) {
            Label(
                title: {
                    Text(item.label.title)
                },
                icon: {
                    Image(systemName: item.label.icon)
                }
            )
        }
        .listItemTint(item.color)
    }
}
