//
//  SearchView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Search View

/// SwiftUI View for search results (macOS)
struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The Music Videos to show
    @State private var musicVideos: [Video.Details.MusicVideo] = []
    /// The TV shows to show
    @State private var tvshows: [Video.Details.TVShow] = []
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// Bool if we have results
    var results: Bool {
        return !movies.isEmpty || !musicVideos.isEmpty || !tvshows.isEmpty
    }
    /// The opacity of the View
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        ScrollView {
            LazyVStack {
                if !results {
                    Label("No results found", systemImage: "magnifyingglass")
                        .font(.title)
                        .padding()
                }
                if !movies.isEmpty {
                    Label("Movies", systemImage: "magnifyingglass")
                        .font(.title)
                        .padding()
                    ForEach(movies) { movie in
                        Divider()
                        Button(
                            action: {
                                selectedItem = MediaItem(id: movie.id, media: .movie, item: movie)
                            },
                            label: {
                                MovieView.Item(movie: movie)
                            }
                        )
                        .buttonStyle(.listButton(selected: selectedItem?.id == movie.id))
                    }
                }
                if !musicVideos.isEmpty {
                    Label("Music Videos", systemImage: "magnifyingglass")
                        .font(.title)
                        .padding()
                    ForEach(musicVideos) { musicVideo in
                        Divider()
                        Button(
                            action: {
                                selectedItem = MediaItem(id: musicVideo.id, media: .musicVideo, item: musicVideo)
                            },
                            label: {
                                MusicVideoView.Item(
                                    item: MediaItem(id: musicVideo.title, media: .musicVideo, item: musicVideo)
                                )
                            }
                        )
                        .buttonStyle(.listButton(selected: selectedItem?.id == musicVideo.id))
                    }
                }
                if !tvshows.isEmpty {
                    Label("TV shows", systemImage: "magnifyingglass")
                        .font(.title)
                        .padding()
                    ForEach(tvshows) { tvshow in
                        NavigationLink(value: tvshow) {
                            TVShowView.Item(tvshow: tvshow)
                        }
                        .buttonStyle(.listButton(selected: false))
                        Divider()
                    }
                }
            }
            .padding()
        }
        .navigationStackAnimation(opacity: $opacity)
        .buttonStyle(.plain)
        .task(id: scene.query) {
            scene.navigationSubtitle = Router.search.label.description
            opacity = 1
            scene.details = .search
            if scene.query.isEmpty {
                movies = []
                musicVideos = []
                tvshows = []
            } else {
                movies = kodi.library.movies.search(scene.query)
                musicVideos = kodi.library.musicVideos.search(scene.query)
                tvshows = kodi.library.tvshows.search(scene.query)
            }
        }
        .task(id: selectedItem) {
            if let selectedItem {
                switch selectedItem.item {
                case let movie as Video.Details.Movie:
                    scene.details = .movie(movie: movie)
                case let musicVideo as Video.Details.MusicVideo:
                    scene.details = .musicVideo(musicVideo: musicVideo)
                default:
                    break
                }
            }
        }
        .task(id: kodi.library.movies) {
            // swiftlint:disable opening_brace
            if
                let selectedItem,
                selectedItem.media == .movie,
                let update = kodi.library.movies.first(where: { $0.id == selectedItem.id })
            {
                movies = kodi.library.movies.search(scene.query)
                self.selectedItem = MediaItem(id: selectedItem.id, media: .movie, item: update)
            }
            // swiftlint:enable opening_brace
        }
        .task(id: kodi.library.musicVideos) {
            // swiftlint:disable opening_brace
            if
                let selectedItem,
                selectedItem.media == .musicVideo,
                let update = kodi.library.musicVideos.first(where: { $0.id == selectedItem.id })
            {
                musicVideos = kodi.library.musicVideos.search(scene.query)
                self.selectedItem = MediaItem(id: selectedItem.id, media: .musicVideo, item: update)
            }
            // swiftlint:enable opening_brace
        }
    }
}
