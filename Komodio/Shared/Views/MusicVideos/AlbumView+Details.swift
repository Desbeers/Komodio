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
        /// The `Music Video Album` to show
        let musicVideoAlbum: Video.Details.MusicVideoAlbum

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: true,
                part: KomodioApp.platform == .macOS ? false : true,
                title: musicVideoAlbum.title
            ) {
                content
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            LazyVStack {
                ForEach(musicVideoAlbum.musicVideos) { musicVideo in
                    Item(musicVideo: musicVideo)
                }
            }
        }
    }
}
