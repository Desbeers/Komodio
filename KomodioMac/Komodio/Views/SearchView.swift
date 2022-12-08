//
//  SearchView.swift
//  Komodio
//
//  Created by Nick Berendsen on 02/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for search results
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
    /// The body of the View
    var body: some View {

        List(selection: $selectedItem) {

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
                        MoviesView.Item(movie: movie)
                            .tag(MediaItem(id: movie.id, media: .movie, item: movie))
                    }
            }
            if !musicVideos.isEmpty {
                Label("Music Videos", systemImage: "magnifyingglass")
                    .font(.title)
                    .padding()
                    ForEach(musicVideos) { musicVideo in
                        MusicVideosView.Item(item: MediaItem(id: musicVideo.id, media: .musicVideo, musicVideos: [musicVideo]))
                            .tag(MediaItem(id: musicVideo.id, media: .musicVideo, item: musicVideo))
                    }
            }
            if !tvshows.isEmpty {
                Label("TV shows", systemImage: "magnifyingglass")
                    .font(.title)
                    .padding()
                    ForEach(tvshows) { tvshow in
                        Button(action: {
                            scene.selectedTVShow = tvshow
                            scene.sidebar = Router.tvshows
                        }, label: {
                            TVShowsView.Item(tvshow: tvshow)
                                .contentShape(Rectangle())
                        })
                    }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .buttonStyle(.plain)
        .task(id: scene.query) {
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
            if let selectedItem, selectedItem.media == .movie, let update = kodi.library.movies.first(where: {$0.id == selectedItem.id}) {
                print("UPDATE")
                movies = kodi.library.movies.search(scene.query)
                self.selectedItem = MediaItem(id: selectedItem.id, media: .movie, item: update)
            }
        }
        .task(id: kodi.library.musicVideos) {
            if let selectedItem, selectedItem.media == .musicVideo, let update = kodi.library.musicVideos.first(where: {$0.id == selectedItem.id}) {
                print("UPDATE")
                musicVideos = kodi.library.musicVideos.search(scene.query)
                self.selectedItem = MediaItem(id: selectedItem.id, media: .musicVideo, item: update)
            }
        }
    }
}

extension SearchView {

    struct Details: View {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        var body: some View {
            Parts.DetailMessage(title: Router.search.label.title, message: "Search results for '**\(scene.query)**'")
        }
    }
}
