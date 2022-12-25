//
//  SearchView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Search' SwiftUI View
struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// The TV shows to show
    @State private var tvshows: [Video.Details.TVShow] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The body of this View
    var body: some View {
        ScrollView {
            if !movies.isEmpty {
                Text("Movies")
                    .font(.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { item in
                        NavigationLink(value: item, label: {
                            KodiArt.Poster(item: item)
                                .frame(width: 150, height: 225)
                        })
                    }
                }
            }
            if !tvshows.isEmpty {
                Text("TV shows")
                    .font(.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { item in
                        NavigationLink(value: item, label: {
                            KodiArt.Poster(item: item)
                                .frame(width: 150, height: 225)
                        })
                        .padding()
                    }
                }
            }
        }
        .navigationDestination(for: Video.Details.Movie.self, destination: { movie in
            MovieView(movie: movie).setSafeAreas()
        })
        .navigationDestination(for: Video.Details.TVShow.self, destination: { tvshow in
            TVShow(tvshow: tvshow).setSafeAreas()
        })
        .padding(.horizontal, 80)
        .buttonStyle(.card)
        .setSafeAreas()
        .searchable(text: $scene.query)
        .task(id: scene.query) {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)

                if scene.query.isEmpty {
                    movies = []
                    tvshows = []
                } else {
                    movies = kodi.library.movies.search(scene.query)
                    tvshows = kodi.library.tvshows.search(scene.query)
                }
            } catch {
                /// Task cancelled without network request
            }
        }
    }
}

extension SearchView {

    struct TVShow: View {
        let tvshow: Video.Details.TVShow
        @State private var selection: Video.Details.TVShow?
        var body: some View {
            SeasonsView(tvshow: $selection)
                .task(id: tvshow) {
                    selection = tvshow
                }
        }
    }
}
