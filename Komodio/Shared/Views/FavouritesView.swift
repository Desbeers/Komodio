//
//  FavouritesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 05/03/2023.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for Favorites (shared)
struct FavouritesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items in this view
    @State private var items: [any KodiItem] = []
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]

    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .favourites, status: state)
            }
        }
        .animation(.default, value: selectedItem)
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
    /// The content of the View
    @ViewBuilder var content: some View {
#if os(macOS)
        List(selection: $selectedItem) {
            ForEach(kodi.favourites, id: \.id) { video in
                switch video {
                case let movie as Video.Details.Movie:
                    MovieView.Item(movie: movie)
                        .tag(MediaItem(id: movie.id, media: .movie))
                case let episode as Video.Details.Episode:
                    UpNextView.Item(episode: episode)
                        .tag(MediaItem(id: episode.id, media: .episode))
                case let musicVideo as Video.Details.MusicVideo:
                    MusicVideoView.Item(item: MediaItem(id: musicVideo.id, media: .musicVideo, item: video))
                        .tag(MediaItem(id: musicVideo.id, media: .musicVideo))
                default:
                    EmptyView()
                }
            }
        }
        .task(id: selectedItem) {
            setItemDetails()
        }
        .onChange(of: kodi.favourites.map(\.playcount)) { _ in
            setItemDetails()
        }
#endif

#if os(tvOS)
        ScrollView {
            VStack {
                PartsView.DetailHeader(title: Router.favourites.label.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(kodi.favourites, id: \.id) { video in
                        switch video {
                        case let movie as Video.Details.Movie:
                            NavigationLink(value: movie, label: {
                                MovieView.Item(movie: movie)
                            })
                            .padding(.bottom, 40)
                        case let episode as Video.Details.Episode:
                            NavigationLink(value: episode, label: {
                                UpNextView.Item(episode: episode)
                            })
                            .padding(.bottom, 40)
                        case let musicVideo as Video.Details.MusicVideo:
                            NavigationLink(value: musicVideo, label: {
                                MusicVideoView.Item(item: MediaItem(id: musicVideo.id, media: .musicVideo, item: video))
                            })
                            .padding(.bottom, 40)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .buttonStyle(.card)
        .frame(maxWidth: .infinity, alignment: .topLeading)
#endif

    }

    // MARK: Private functions

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem {
            switch selectedItem.media {
            case .movie:
                if let movie = kodi.library.movies.first(where: {$0.id == selectedItem.id}) {
                    scene.details = .movie(movie: movie)
                }
            case .episode:
                if let episode = kodi.library.episodes.first(where: {$0.id == selectedItem.id}) {
                    scene.details = .episode(episode: episode)
                }
            case .musicVideo:
                if let musicVideo = kodi.library.musicVideos.first(where: {$0.id == selectedItem.id}) {
                    scene.details = .musicVideo(musicVideo: musicVideo)
                }
            default:
                break
            }
        } else {
            scene.navigationSubtitle = Router.favourites.label.title
            scene.details = .favourites
        }
    }
}
