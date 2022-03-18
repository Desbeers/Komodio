//
//  AlbumsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct AlbumsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The artist
    let artist: MediaItem
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#endif
    /// The View
    var body: some View {
        ItemsView.List() {
            LazyVGrid(columns: grid, spacing: 30) {
                ForEach(kodi.media.filter(MediaFilter(media: .album, artist: artist.artists))) { album in
                    RouterLink(item: .songs(album: album)) {
                        VStack(spacing: 0) {
                            ArtView.PosterDetail(item: album)
                                .macOS { $0.frame(height: 300) }
                                .tvOS { $0.frame(width: 300, height: 300) }
                                .iOS { $0.frame(height: 200) }
                                Text(album.title)
                                    .font(.caption)
                        }
                        .frame(width: 300)
                    }

                }
                .buttonStyle(ButtonStyles.HomeItem())
            }
            .macOS { $0.padding(.top, 40) }
            .tvOS { $0.padding(.horizontal, 100) }
        }
    }
}
