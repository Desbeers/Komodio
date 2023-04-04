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
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The body of the View
    var body: some View {
        ScrollView {
#if os(macOS)
            PartsView.DetailHeader(title: musicVideos.first?.album ?? "Album")
#endif
            ForEach(musicVideos) { musicVideo in
                Item(musicVideo: musicVideo)
            }
        }
    }
}
