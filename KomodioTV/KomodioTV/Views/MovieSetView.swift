//
//  MovieSetView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Set item for this View
    let set: MediaItem
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// The View
    var body: some View {
        VStack {
            /// Header
            PartsView.Header(title: set.title, subtitle: selectedItem?.title)
            if !set.description.isEmpty {
                Text(set.description)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach($movies) { $movie in
                        NavigationLink(destination: DetailsView(item: $movie)) {
                            ArtView.Poster(item: movie)
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
            }
            VStack {
            if let selected = selectedItem {
                Text(selected.details)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            }
            .frame(height: 200)
        }
        .background(ArtView.SelectionBackground(item: selectedItem))
        .animation(.default, value: selectedItem)
        .task {
            movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie, movieSetID: set.movieSetID))
        }
    }
}
