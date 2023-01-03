//
//  AlbumsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an album of a selected Artist
struct AlbumView: View {
    /// The title of the Album
    let title: String
    /// The Music Videos to show
    let musicVideos: [Video.Details.MusicVideo]
    /// The body of the View
    var body: some View {
        List {
            ForEach(musicVideos) { musicVideo in
                Item(musicVideo: musicVideo)
            }
        }
        #if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
        #endif
    }
}

extension AlbumView {

    /// SwiftUI View for a music video in ``AlbumView``
    struct Item: View {
        /// The Music Video
        let musicVideo: Video.Details.MusicVideo
        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Art(file: musicVideo.art.icon)
                    .watchStatus(of: musicVideo)
                    .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                    .cornerRadius(KomodioApp.thumbSize.width / 35)
                    .padding()
                VStack(alignment: .leading) {
                    Text(musicVideo.title)
                        .font(.headline)
                    HStack {
                        Buttons.Player(item: musicVideo)
                    }
                }
            }
        }
    }
}
