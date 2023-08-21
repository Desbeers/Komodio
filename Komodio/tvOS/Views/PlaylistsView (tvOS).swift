//
//  PlaylistsView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Playlists View

/// SwiftUI `View` for playlists (tvOS)
struct PlaylistsView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .moviePlaylists, status: state)
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
            scene.detailSelection = .moviePlaylists
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.moviePlaylists.item.title,
                    subtitle: Router.moviePlaylists.item.description
                )
            },
            content: {
                HStack {
                    ScrollView {
                        ForEach(kodi.library.moviePlaylists, id: \.file) { playlist in

                            Button(action: {
                                scene.navigationStack.append(.moviePlaylist(file: playlist))
                                scene.detailSelection = .moviePlaylist(file: playlist)
                            }, label: {
                                Label(title: {
                                    Text(playlist.title)
                                        .frame(width: 400, alignment: .leading)
                                }, icon: {
                                    Image(systemName: Router.moviePlaylists.item.icon)
                                })
                            })
                            .padding()
                        }
                    }
                    DetailView()
                        .frame(width: 800)
                }
            },
            buttons: {}
        )
    }
}
