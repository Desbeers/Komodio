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
    let grid = [GridItem(.adaptive(minimum: 200))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 154))]
#endif
    init() {
        movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie))
    }
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { movie in
                        RouterLink(item: movie.movieSetID == 0 ? .details(item: movie) : .moviesSet(set: movie)) {
                                ArtView.Poster(item: movie)
                                .watchStatus(of: movie.binding())
                                    .macOS { $0.frame(width: 150) }
                                    .tvOS { $0.frame(width: 200) }
                                    .iOS { $0.frame(height: 200) }
                        }
                        .buttonStyle(ButtonStyles.MediaItem(item: movie))
                    }
                }
                .padding(.horizontal, 20)
            }
            /// Make room for the details
            .macOS { $0.padding(.leading, 330) }
            .tvOS { $0.padding(.leading, 550) }
            if router.selectedMediaItem != nil {
                ItemsView.Details(item: router.selectedMediaItem!)
            }
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            logger("Movies task: \(movies.count)")
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: movies.first)
            }
        }
    }
}
