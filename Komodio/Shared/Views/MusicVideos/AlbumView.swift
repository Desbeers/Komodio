//
//  AlbumsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Album View

/// SwiftUI View for an album of a selected Artist (shared)
struct AlbumView: View {
    /// The Music Videos to show
    let musicVideos: [Video.Details.MusicVideo]
    /// The body of the View
    var body: some View {
#if os(macOS)
        ScrollView {
            PartsView.DetailHeader(title: musicVideos.first?.album ?? "Album")
            ForEach(musicVideos) { musicVideo in
                Item(musicVideo: musicVideo)
            }
        }
#endif

#if os(tvOS) || os(iOS)
        List {
            ForEach(musicVideos) { musicVideo in
                Item(musicVideo: musicVideo)
            }
        }
#endif
    }
}
