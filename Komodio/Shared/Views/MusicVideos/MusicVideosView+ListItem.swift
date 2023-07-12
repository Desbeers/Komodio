//
//  MusicVideosView+ListItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MusicVideosView {

    // MARK: Music Video List Item

    /// SwiftUI `View` for a `Music Video` list item
    ///
    /// - This can be an `Music Video Album` or a single `Music Video`
    struct ListItem: View {
        /// The `KodiItem`
        let item: any KodiItem

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            HStack {
                KodiArt.Poster(item: item)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: item)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text("Year: \(item.year.description)")
                }
#endif
            }
        }
    }
}
