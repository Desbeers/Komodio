//
//  AlbumsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct AlbumsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The artist
    private var artist: MediaItem
    /// The albums to show
    private var albums: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#endif
    /// Init the view
    init(artist: MediaItem) {
        self.artist = artist
        self.albums = KodiConnector.shared.media.filter(MediaFilter(media: .album, artist: artist.artists))
    }
    /// The View
    var body: some View {
        ItemsView.List(details: artist) {
            LazyVGrid(columns: grid, spacing: 30) {
                ForEach(albums) { album in
                    RouterLink(item: .songs(album: album)) {
                        VStack(spacing: 0) {
                            ArtView.Poster(item: album)
//                                Text(album.title)
//                                    .font(.caption)
                        }
                    }
                    .buttonStyle(ButtonStyles.MediaItem(item: album))

                }
            }
            //.macOS { $0.padding(.top, 40) }
            .tvOS { $0.padding(.horizontal, 100) }
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            /// Select the first item in the list
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: albums.first)
            }
        }
    }
}
