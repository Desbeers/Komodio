//
//  ArtistView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single Artist (shared)
enum ArtistView {
    // Just a NameSpace here
}

extension ArtistView {

    // MARK: Artist item

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
            }
#endif

#if os(tvOS)
            VStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: KomodioApp.posterSize.height, height: KomodioApp.posterSize.height)
                Text(artist.artist)
                    .font(.caption)
            }
#endif
        }
    }
}

extension ArtistView {

    // MARK: Artist details

    /// SwiftUI View for Artist details
    struct Details: View {
        /// The Artist
        let artist: Audio.Details.Artist

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(artist.artist)
                        .font(.largeTitle)
                        .padding(.bottom)
                    KodiArt.Fanart(item: artist)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                    Text(artist.description)
                }
                .detailsFontStyle()
                .padding(40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(item: artist)
#endif

#if os(tvOS)
            VStack {
                Text(artist.artist)
                    .font(.largeTitle)
                    .padding(.bottom)
                KodiArt.Fanart(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Text(artist.description)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(item: artist)
#endif

        }
    }
}
