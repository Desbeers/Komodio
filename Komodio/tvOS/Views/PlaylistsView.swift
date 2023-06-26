//
//  PlaylistsView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Playlists View

/// SwiftUI View for playlists (tvOS)
struct PlaylistsView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .playlists, status: state)
                    .focusable()
            }
        }
        .task(id: kodi.library.moviePlaylists) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.moviePlaylists.isEmpty {
                state = .empty
            } else {
                state = .ready
            }
            scene.details = .playlists
        }
    }

    // MARK: Content of the View

    /// The content of the View
    var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.playlists.label.title,
                    subtitle: Router.playlists.label.description
                )
            },
            content: {
                HStack {
                    ScrollView {
                        ForEach(kodi.library.moviePlaylists, id: \.file) { playlist in
                            NavigationLink(value: playlist) {
                                Label(title: {
                                    Text(playlist.title)
                                        .frame(width: 400, alignment: .leading)
                                }, icon: {
                                    Image(systemName: Router.playlists.label.icon)
                                })
                            }
                            .padding()
                        }
                    }
                    DetailView()
                        .frame(width: 800)
                }
            })
    }
}
