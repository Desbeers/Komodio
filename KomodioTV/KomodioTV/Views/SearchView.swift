//
//  SearchView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 29/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SearchView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The search text
    @State private var searchText = ""
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The body of this View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(movies) { item in
                    NavigationLink(destination: DetailsView(item: item)) {
                        KodiArt.Poster(item: item)
                            .frame(width: 300, height: 450)
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 80)
        }
        .buttonStyle(.card)
        .searchable(text: $searchText)
        
        .task(id: searchText) {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                movies = kodi.library.movies.filter({$0.title.contains(searchText)})
            } catch {
                // Task cancelled without network request.
            }
        }

    }
}
