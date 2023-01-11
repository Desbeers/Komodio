//
//  AlbumsView.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an album of a selected Artist
struct AlbumView: View {
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
        /// The focus state of the Movie View (for tvOS)
        @FocusState var isFocused: Bool

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            HStack(spacing: 0) {
                KodiArt.Art(file: musicVideo.art.icon)
                    .watchStatus(of: musicVideo)
                    .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                    .cornerRadius(KomodioApp.thumbSize.width / 35)
                    .padding()
                VStack(alignment: .leading) {
                    Text(musicVideo.title)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Divider()
                    HStack {
                        Buttons.Player(item: musicVideo)
                    }
                }
            }
#endif

#if os(tvOS)
            HStack(spacing: 0) {
                KodiArt.Art(file: musicVideo.art.icon)
                    .watchStatus(of: musicVideo)
                    .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(KomodioApp.thumbSize.width / 35)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(musicVideo.title)
                        .font(.title3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Rectangle().fill(.secondary).frame(height: 1)
                    Buttons.Player(item: musicVideo, state: false)
                        .opacity(isFocused ? 1 : 0.5)
                }
            }
            .focused($isFocused)
            .animation(.default, value: isFocused)
#endif

        }
    }
}
