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
    /// The search text
    @State private var searchText = ""
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
                        NavigationLink(destination: DetailsView(item: item)) {
                            KodiArt.Poster(item: item)
                                .frame(width: 150, height: 225)
                        }
                        .padding()
                    }
                }
            }
            if !tvshows.isEmpty {
                Text("TV shows")
                    .font(.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { item in
                        NavigationLink(destination: DetailsView(item: item)) {
                            KodiArt.Poster(item: item)
                                .frame(width: 150, height: 225)
                        }
                        .padding()
                    }
                }
            }
        }
        .padding(.horizontal, 80)
        .buttonStyle(.card)
        .searchable(text: $searchText)
        .task(id: searchText) {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                
                if searchText.isEmpty {
                    movies = []
                    tvshows = []
                } else {
                    movies = kodi.library.movies.search(searchText)
                    tvshows = kodi.library.tvshows.search(searchText)
                }
            } catch {
                /// Task cancelled without network request
            }
        }
    }
}
