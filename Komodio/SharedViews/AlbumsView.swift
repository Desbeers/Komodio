//
//  AlbumsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 09/03/2022.
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
    let grid = [GridItem(.adaptive(minimum: 320))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#endif
    /// The View
    var body: some View {
        ItemsView.List() {
        //ScrollView {
            LazyVGrid(columns: grid, spacing: 30) {
                ForEach(kodi.media.filter(MediaFilter(media: .album, artist: artist.artists))) { album in
                    RouterLink(item: .genresItems(genre: album)) {
                        VStack(spacing: 0) {
                            ArtView.PosterDetail(item: album)
                                .macOS { $0.frame(height: 300) }
                                .tvOS { $0.frame(height: 500) }
                                .iOS { $0.frame(height: 200) }
                                Text(album.title)
                                    .font(.caption)                        }
                    }

                }
                .buttonStyle(ButtonStyles.HomeItem())
                //.buttonStyle(ButtonStyles.GridItem())
            }
            .tvOS { $0.padding(.horizontal, 100) }
            .macOS { $0.padding(.top, 40) }
        }
        .task {
            logger("GenresView task!")
        }
    }
}
