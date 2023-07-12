//
//  MoviesView+ListItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MoviesView {

    // MARK: Movie List Item

    /// SwiftUI `View` for a `Movie` list item
    struct ListItem: View {
        /// The `Movie`
        let movie: Video.Details.Movie
        /// The optional sorting
        var sorting: SwiftlyKodiAPI.List.Sort?

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            HStack {
                KodiArt.Poster(item: movie)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: movie)
#if canImport(UIKit)
                    .overlay(alignment: .bottom) {
                        if let sorting {
                            PartsView.SortLabel(item: movie, sorting: sorting)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .background(.thinMaterial)
                        }
                    }
#endif

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    Text(movie.genre.joined(separator: "∙"))
                    if let sorting {
                        PartsView.SortLabel(item: movie, sorting: sorting)
                            .font(.caption)
                    }
                }
#endif
            }
        }
    }
}
