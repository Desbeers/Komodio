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
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show
    private var movies: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 154))]
#endif
    init() {
        movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie))
    }
    /// The View
    var body: some View {
        ItemsView.List(details: router.selectedMediaItem) {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(movies) { movie in
                    RouterLink(item: movie.movieSetID == 0 ? .details(item: movie) : .moviesSet(set: movie)) {
                        ArtView.Poster(item: movie)
                            .watchStatus(of: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.MediaItem(item: movie, doubleClick: true))
                }
            }
            .padding(.horizontal, 20)
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            /// Select the first item in the list
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: movies.first)
            }
        }
    }
}
