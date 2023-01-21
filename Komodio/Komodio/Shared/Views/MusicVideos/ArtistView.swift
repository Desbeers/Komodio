//
//  ArtistView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an Artist (shared)
enum ArtistView {
    // Just a NameSpace here
}

extension ArtistView {

    /// SwiftUI View for details of an Artist
    struct Details: View {
        /// The Artist
        let artist: Audio.Details.Artist

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
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
        }
    }
}
