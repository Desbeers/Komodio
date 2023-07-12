//
//  ArtistView+ListItem.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension ArtistsView {

    // MARK: Artist Item

    /// SwiftUI `View` for an `Artist` list item
    struct ListItem: View {
        /// The `Artist`
        let artist: Audio.Details.Artist
        /// The body of the `View`
        var body: some View {
#if os(macOS)
            HStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.width)
                VStack(alignment: .leading) {
                    Text(artist.artist)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.forward")
                        .font(.title3)
                        .padding(.trailing)
                }
            }
#endif

#if os(tvOS) || os(iOS)
            KodiArt.Poster(item: artist)
                .aspectRatio(contentMode: .fit)
                .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.width)
                .overlay(alignment: .bottom) {
                    Text(artist.artist)
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                }
#endif
        }
    }
}
