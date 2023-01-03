//
//  ArtistView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

enum ArtistView {
    // Jus a NameSpace here
}

extension ArtistView {

    /// SwiftUI View for an Artist details
    struct Details: View {
        /// The Artist
        let artist: Audio.Details.Artist
        /// The body of the View
        var body: some View {
            VStack {
                Text(artist.artist)
                    .font(.largeTitle)
                    .padding(.bottom)
                KodiArt.Fanart(item: artist)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Text(artist.description)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(file: artist.fanart)
        }
    }
}
