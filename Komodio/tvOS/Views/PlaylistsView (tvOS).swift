//
//  PlaylistsView.swift
//  Komodio (tvOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Playlists View

/// SwiftUI `View` for playlists (tvOS)
struct PlaylistsView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The loading state of the View
    @State private var status: ViewStatus = .loading

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch status {
            case .ready:
                content
            default:
                status.message(router: .moviePlaylists)
                    .focusable()
            }
        }
        .animation(.default, value: status)
        .task(id: kodi.library.moviePlaylists) {
            if kodi.status != .loadedLibrary {
                status = .offline
            } else if kodi.library.moviePlaylists.isEmpty {
                status = .empty
            } else {
                status = .ready
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
                    .padding(.top, StaticSetting.detailPadding)
                    DetailView()
                        .frame(width: 800)
                }
            },
            buttons: {}
        )
    }
}
