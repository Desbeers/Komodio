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
    /// The body of the view
    var body: some View {
        List {
            ForEach(musicVideos) { musicVideo in
                Item(musicVideo: musicVideo)
            }
        }
        .modifier(Modifiers.ContentListStyle())
    }
}

extension AlbumView {

    /// SwiftUI View for a music video in ``AlbumView``
    struct Item: View {
        /// The Music Video
        let musicVideo: Video.Details.MusicVideo
        /// The body of the view
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Art(file: musicVideo.art.icon)
                    .watchStatus(of: musicVideo)
                    .frame(width: 213, height: 120)
                    .cornerRadius(6)
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
