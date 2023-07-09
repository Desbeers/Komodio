//
//  SearchView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Search View

/// SwiftUI View for search results (tvOS)
struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The TV shows to show
    @State private var tvshows: [Video.Details.TVShow] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The body of this View
    var body: some View {
        ContentView.Wrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(
                    title: Router.search.item.title,
                    subtitle: Router.search.item.description
                )
            }, content: {
                Grid {
                    if !movies.isEmpty {
                        GridRow {
                            Text("Movies")
                                .font(.headline)
                                .frame(width: 200)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(movies) { movie in
                                        NavigationLink(value: Router.movie(movie: movie)) {
                                            KodiArt.Poster(item: movie)
                                                .frame(width: 150, height: 225)
                                        }
                                        .padding(KomodioApp.contentPadding)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    if !tvshows.isEmpty {
                        GridRow {
                            Text("TV shows")
                                .font(.headline)
                                .frame(width: 200)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(tvshows) { tvshow in
                                        NavigationLink(value: Router.tvshow(tvshow: tvshow)) {
                                            KodiArt.Poster(item: tvshow)
                                                .frame(width: 150, height: 225)
                                        }
                                        .padding(KomodioApp.contentPadding)
                                    }
                                }
                            }
                        }
                    }
                }
                .buttonStyle(.card)
                .searchable(text: $scene.query)
                .task(id: scene.query) {
                    do {
                        try await Task.sleep(until: .now + .seconds(0.3), clock: .continuous)

                        if scene.query.isEmpty {
                            movies = []
                            tvshows = []
                        } else {
                            movies = kodi.library.movies.search(scene.query)
                            tvshows = kodi.library.tvshows.search(scene.query)
                        }
                    } catch {
                        // Task cancelled without network request
                    }
                }
            })
    }
}
