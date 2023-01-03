//
//  SearchView.swift
//  KomodioTV
//
//  © 2023 Nick Berendsen
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
        Grid {
            if !movies.isEmpty {
                GridRow {
                    Text("Movies")
                        .font(.headline)
                        .frame(width: 200)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(movies) { item in
                                NavigationLink(value: item, label: {
                                    KodiArt.Poster(item: item)
                                        .frame(width: 150, height: 225)
                                })
                                .padding(40)
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
                            ForEach(tvshows) { item in
                                NavigationLink(value: item, label: {
                                    KodiArt.Poster(item: item)
                                        .frame(width: 150, height: 225)
                                })
                                .padding(40)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(maxWidth: .infinity)
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
                // Task cancelled without network request
            }
        }
    }
}
