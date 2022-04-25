//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for Movie items
struct MoviesView: View {
    /// The KodiConnector model
    //@EnvironmentObject var kodi: KodiConnector
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// Init the View
    /// The View
    var body: some View {
        VStack(spacing: 0 ) {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { movie in
                        Group {
                            if movie.movieSetID == 0 {
                                NavigationLink(destination: DetailsView(item: movie)) {
                                    ArtView.Poster(item: movie)
                                }
                            } else {
                                NavigationLink(destination: MovieSetView(set: movie)) {
                                    ArtView.Poster(item: movie)
                                }
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
            }
            if let item = selectedItem {
                VStack {
                    Text(item.title)
                        .font(.title3)
                    Text(item.description)
                        .lineLimit(2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .animation(.default, value: selectedItem)
        .task {
            movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie))
        }
    }
}
