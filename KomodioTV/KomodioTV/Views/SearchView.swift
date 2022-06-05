//
//  SearchView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 29/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SearchView: View {
    /// The search text
    @State private var searchText = ""
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The body of this View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach($movies) { $item in
                    NavigationLink(destination: DetailsView(item: $item)) {
                        ArtView.Poster(item: item)
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 80)
        }
        .buttonStyle(.card)
        .searchable(text: $searchText)
        .onChange(of: searchText) { text in
            print(text)
            if text.isEmpty {
                movies =  []
            } else {
                movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie)).filter { $0.title.contains(text) }
            }
        }
    }
}
