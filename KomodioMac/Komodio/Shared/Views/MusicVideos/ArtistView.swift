//
//  ArtistView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an Artist
struct ArtistView: View {
    /// The Artist
    let artist: Audio.Details.Artist
    /// The body of the View
    var body: some View {
        Text(artist.artist)
    }
}
