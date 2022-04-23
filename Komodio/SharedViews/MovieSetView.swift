//
//  MovieSetView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieSetView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Set item for this View
    private var set: MediaItem
    /// The movies to show
    private var movies: [MediaItem]
    init(set: MediaItem) {
        self.set = set
        movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie, movieSetID: set.movieSetID))
    }
    /// The View
    var body: some View {
        ItemsView.List() {
            LazyVStack(spacing: 0) {
                if !set.description.isEmpty {
                    ItemsView.Description(description: set.description)
                }
                ForEach(movies) { movie in
                    RouterLink(item: .details(item: movie)) {
                        ItemsView.Basic(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.MediaItem(item: movie))
                }
            }
            .macOS { $0.padding(.horizontal, 80) }
            .tvOS { $0.padding(.horizontal, 160) }
        }
        .task {
            logger("MovieSet task: \(movies.count)")
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: movies.first)
            }
        }
    }
}
