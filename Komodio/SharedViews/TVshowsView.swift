//
//  TVshowsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct TVshowsView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
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
            appState.filter.title = "TV shows"
            appState.filter.subtitle = nil
            
        }
        .iOS { $0.navigationTitle("TV shows") }
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
            StackNavLink(path: "/TV shows/Episodes/\(tvshow.id)", filter: filter, destination: EpisodesView(tvshow: tvshow)) {
                ItemsView.Item(item: tvshow.binding())
            }
            .buttonStyle(ButtonStyles.KodiItem(item: tvshow))
        }
    }
}
