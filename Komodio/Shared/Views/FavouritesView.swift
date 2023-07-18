//
//  FavouritesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 05/03/2023.
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Favorites View

/// SwiftUI `View` for Favorites (shared)
struct FavouritesView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items in this view
    @State private var items: [any KodiItem] = []
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
                PartsView.StatusMessage(router: .favourites, status: state)
            }
        }
        .animation(.default, value: items.map(\.id))
        .task {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.favourites.isEmpty {
                state = .empty
            } else {
                state = .ready
            }
        }
    }
    /// The content of the `View`
    @ViewBuilder var content: some View {
#if os(macOS)
        List {
            ForEach(kodi.favourites, id: \.id) { video in
                Group {
                    switch video {
                    case let movie as Video.Details.Movie:
                        Button(
                            action: {
                                scene.detailSelection = .movie(movie: movie)
                            },
                            label: {
                                MoviesView.ListItem(movie: movie)
                            }
                        )
                    case let episode as Video.Details.Episode:
                        Button(
                            action: {
                                scene.detailSelection = .episode(episode: episode)
                            },
                            label: {
                                EpisodeView.ListItem(episode: episode)
                            }
                        )
                    case let musicVideo as Video.Details.MusicVideo:
                        Button(
                            action: {
                                scene.detailSelection = .musicVideo(musicVideo: musicVideo)
                            },
                            label: {
                                MusicVideosView.ListItem(item: musicVideo)
                            }
                        )
                    default:
                        EmptyView()
                    }
                }
                .buttonStyle(.kodiItemButton(kodiItem: video))
            }
        }
#endif

#if os(tvOS) || os(iOS)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.favourites.item.title,
                    subtitle: Router.favourites.item.description
                )
            },
            content: {
                LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                    ForEach(kodi.favourites, id: \.id) { video in
                        switch video {
                        case let movie as Video.Details.Movie:
                            NavigationLink(value: Router.movie(movie: movie), label: {
                                MoviesView.ListItem(movie: movie)
                            })
                            .padding(.bottom, KomodioApp.posterSize.height / 9)
                        case let episode as Video.Details.Episode:
                            NavigationLink(value: Router.episode(episode: episode), label: {
                                EpisodeView.ListItem(episode: episode)
                            })
                            .padding(.bottom, KomodioApp.posterSize.height / 9)
                        case let musicVideo as Video.Details.MusicVideo:
                            NavigationLink(value: Router.musicVideo(musicVideo: musicVideo), label: {
                                MusicVideosView.ListItem(item: musicVideo)
                            })
                            .padding(.bottom, KomodioApp.posterSize.height / 9)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        )
        .backport.cardButton()
#endif
    }
}
