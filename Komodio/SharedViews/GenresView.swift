//
//  GenresView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

/// A View for Genre items
struct GenresView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 320))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 160))]
#endif
    /// The View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 30) {
                ForEach(kodi.media.filter(MediaFilter(media: .genre))) { genre in
                    RouterLink(item: .genresItems(genre: genre)) {
                        Label(genre.title, systemImage: genre.poster)
                            .labelStyle(LabelStyles.GridItem())
                            .tvOS { $0.frame(width: 260, height: 120) }
                            .macOS { $0.frame(width: 130, height: 60) }
                    }

                }
                .buttonStyle(ButtonStyles.GridItem())
            }
            .macOS { $0.padding(.top, 40) }
        }
        .task {
            logger("GenresView task!")
        }
        .tvOS { $0.padding(.horizontal, 100) }
    }
}

extension GenresView {
    
    /// A view with all items of a certain genre
    struct Items: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The selected Genre to filter
        let genre: MediaItem
        /// The View
        var body: some View {
            ItemsView.List() {
                ForEach(kodi.media.filter(MediaFilter(media: .all, genre: genre.title))) { item in
                    ItemsView.Item(item: item.binding())
                }
            }
        }
    }
}
