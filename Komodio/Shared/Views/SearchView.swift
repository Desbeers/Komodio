//
//  SearchView.swift
//  Komodio (macOS +iOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Search View

/// SwiftUI View for search results (macOS + iOS)
/// - Note: tvOS has its own `View`
struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The Music Videos to show
    @State private var musicVideos: [Video.Details.MusicVideo] = []
    /// The TV shows to show
    @State private var tvshows: [Video.Details.TVShow] = []
    /// Bool if we have results
    var results: Bool {
        return !movies.isEmpty || !musicVideos.isEmpty || !tvshows.isEmpty
    }
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        content
#else
        VStack {
            Divider()
                .opacity(0)
            HStack {
                content
                    .frame(width: KomodioApp.posterSize.width * 2)
                DetailView()
            }
        }
#endif
    }

    // MARK: Content of the View

    /// The content of the View
    var content: some View {
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
                                scene.details = .movie(movie: movie)
                            },
                            label: {
                                MovieView.Item(movie: movie)
                            }
                        )
                        .buttonStyle(.kodiItemButton(kodiItem: movie))
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
                                scene.details = .musicVideo(musicVideo: musicVideo)
                            },
                            label: {
                                MusicVideoView.Item(item: musicVideo)
                            }
                        )
                        .buttonStyle(.kodiItemButton(kodiItem: musicVideo))
                    }
                }
                if !tvshows.isEmpty {
                    Label("TV shows", systemImage: "magnifyingglass")
                        .font(.title)
                        .padding()
                    ForEach(tvshows) { tvshow in
                        NavigationLink(value: Router.tvshow(tvshow: tvshow)) {
                            TVShowView.Item(tvshow: tvshow)
                        }
                        .buttonStyle(.kodiItemButton(kodiItem: tvshow))
                        Divider()
                    }
                }
            }
            .padding()
        }
        .buttonStyle(.plain)
        .task(id: scene.query) {
            scene.details = .search
            search()
        }
        .onChange(of: kodi.library) { _ in
            search()
        }
    }

    /// Perform the search
    @MainActor private func search() {
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
}
