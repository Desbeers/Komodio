//
//  TVshowsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct TVshowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(kodi.media.filter(MediaFilter(media: .tvshow))) { tvshow in
                Item(tvshow: tvshow.binding())
            }
        }
        .task {
            logger("TVshowView task!")
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
