//
//  TVshowsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI

struct TVshowsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The TV shows to show
    private var tvshows: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 154))]
#endif
    init() {
        tvshows = KodiConnector.shared.media.filter(MediaFilter(media: .tvshow))
    }
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { tvshow in
                        RouterLink(item: .episodes(tvshow: tvshow)) {
                                ArtView.Poster(item: tvshow)
//                                    .macOS { $0.frame(width: 150) }
//                                    .tvOS { $0.frame(width: 200) }
//                                    .iOS { $0.frame(height: 200) }
                        }
                        .buttonStyle(ButtonStyles.MediaItem(item: tvshow, doubleClick: true))
                    }
                }
                .padding(.horizontal, 20)
            }
            /// Make room for the details
            .macOS { $0.padding(.leading, 330) }
            .tvOS { $0.padding(.leading, 550) }
            if router.selectedMediaItem != nil {
                ItemsView.Details(item: router.selectedMediaItem!)
            }
        }
        .animation(.default, value: router.selectedMediaItem)
        .task {
            logger("TV show task: \(tvshows.count)")
            if router.selectedMediaItem == nil {
                router.setSelectedMediaItem(item: tvshows.first)
            }
        }
    }
}

extension TVshowsView {
    
    /// View a TV show item
    struct Item: View {
        /// The TV show item
        @Binding var tvshow: MediaItem
        /// The View
        var body: some View {
            RouterLink(item: .episodes(tvshow: tvshow)) {
                ItemsView.Basic(item: tvshow.binding())
            }
            .buttonStyle(ButtonStyles.MediaItem(item: tvshow))
        }
    }
}
