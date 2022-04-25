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
    private var set: MediaItem
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The movies to show
    private var movies: [MediaItem]
    /// Init the View
    init(set: MediaItem) {
        self.set = set
        movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie, movieSetID: set.movieSetID))
    }
    /// The View
    var body: some View {
        VStack {
            if !set.description.isEmpty {
                Text(set.description)
            }
            if let selected = selectedItem {
                Text(selected.title)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: DetailsView(item: movie)) {
                            ArtView.Poster(item: movie)
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
            }
            if let selected = selectedItem {
                Text(selected.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle(set.title)
        .animation(.default, value: selectedItem)
    }
}
