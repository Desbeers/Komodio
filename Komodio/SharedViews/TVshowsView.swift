//
//  TVshowsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct TVshowsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The library filter
    @State var filter: KodiFilter
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(kodi.library.filter(filter)) { tvshow in
                Item(tvshow: tvshow.binding(), filter: filter)
            }
        }
        .task {
            print("TVsshowView task!")
            /// Set fanart
            //router.fanart = ""
        }
    }
}

extension TVshowsView {
    
    /// View a TV show item
    struct Item: View {
        /// The TV show item
        @Binding var tvshow: KodiItem
        /// The current filter
        let filter: KodiFilter
        var body: some View {
            RouterLink(item: .episodes(tvshow: tvshow)) {
                ItemsView.Basic(item: tvshow.binding())
            }
            .buttonStyle(ButtonStyles.KodiItem(item: tvshow))
        }
    }
}
