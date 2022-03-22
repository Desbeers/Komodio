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
    
    @Namespace private var namespace
    
    @FocusState private var focus: Bool
    
    @FocusState private var focusedMediaItem: MediaItem?
    
    /// The TV shows to show
    private var tvshows: [MediaItem]
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 200))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 150))]
#endif
    init() {
        tvshows = KodiConnector.shared.media.filter(MediaFilter(media: .tvshow))
        //focusedMediaItem = Router.shared.selectedMediaItem
    }
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { tvshow in
                        RouterLink(item: .episodes(tvshow: tvshow)) {
                                ArtView.PosterDetail(item: tvshow)
                                    .macOS { $0.frame(width: 150) }
                                    .tvOS { $0.frame(width: 200) }
                                    .iOS { $0.frame(height: 200) }
                        }
                        .buttonStyle(ButtonStyles.HomeItem(item: tvshow))
                    }
                }
                .focusScope(namespace)
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

//struct TVshowsView: View {
//    /// The KodiConnector model
//    @EnvironmentObject var kodi: KodiConnector
//    /// The View
//    var body: some View {
//        ItemsView.List() {
//            ForEach(kodi.media.filter(MediaFilter(media: .tvshow))) { tvshow in
//                Item(tvshow: tvshow.binding())
//            }
//        }
//    }
//}

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
