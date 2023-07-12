//
//  TVShowsView+ListItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension TVShowsView {

    // MARK: TV show List Item

    /// SwiftUI `View` for a `TV show` list item
    struct ListItem: View {
        /// The `TV show`
        let tvshow: Video.Details.TVShow

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            HStack {
                KodiArt.Poster(item: tvshow)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: tvshow)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(tvshow.title)
                        .font(.headline)
                    Text(tvshow.genre.joined(separator: "∙"))
                    Text(tvshow.year.description)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.forward")
                        .font(.title3)
                        .padding(.trailing)
                }
#endif
            }
        }
    }
}
