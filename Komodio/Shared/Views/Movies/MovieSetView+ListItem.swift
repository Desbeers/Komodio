//
//  MovieSetView+ListItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MovieSetView {

    // MARK: Movie Set List Item

    /// SwiftUI `View` for a `MovieSet` list item
    struct ListItem: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet
        /// The body of the `View`
        var body: some View {
            HStack {
                KodiArt.Poster(item: movieSet)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: movieSet)
#if os(macOS)
                VStack(alignment: .leading) {
                    Text(movieSet.title)
                        .font(.headline)
                    Text("Movie Set")
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
