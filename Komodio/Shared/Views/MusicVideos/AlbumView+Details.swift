//
//  AlbumView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension AlbumView {

    // MARK: Album Details

    /// SwiftUI `View` for details of a `MusicVideoAlbum`
    struct Details: View {
        /// The `Music Videos` to show
        let musicVideos: [Video.Details.MusicVideo]

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: true,
                part: KomodioApp.platform == .macOS ? false : true,
                title: musicVideos.first?.album ?? "Album"
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            LazyVStack {
                ForEach(musicVideos) { musicVideo in
                    Item(musicVideo: musicVideo)
                }
            }
        }
    }
}
