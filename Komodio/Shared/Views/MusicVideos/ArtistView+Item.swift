//
//  ArtistView+Item.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension ArtistView {

    // MARK: Artist Item

    /// SwiftUI View for an Artist item
    struct Item: View {
        /// The artist
        let artist: Audio.Details.Artist
        /// The body of the View
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
            VStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.width)
                    .overlay(alignment: .bottom) {
                        Text(artist.artist)
                            .font(KomodioApp.platform == .tvOS ? .caption : .title)
                            .foregroundColor(.primary)
                            .scaleEffect(0.8)
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                    }
            }
#endif
        }
    }
}
