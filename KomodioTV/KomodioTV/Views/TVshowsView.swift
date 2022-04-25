//
//  TVshowsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for TV show items
struct TVshowsView: View {
    /// The KodiConnector model
    //@EnvironmentObject var kodi: KodiConnector
    /// The tv shows to show
    @State private var tvshows: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The View
    var body: some View {
        VStack(spacing: 0 ) {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { tvshow in
                        //NavigationLink(destination: DetailsView(item: tvshow)) {
                        NavigationLink(destination: EpisodesView(tvshow: tvshow)) {
                            ArtView.Poster(item: tvshow)
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: tvshow)
                        .zIndex(tvshow == selectedItem ? 2 : 1)
                    }
                }
            }
            if let item = selectedItem {
                VStack {
                    Text(item.title)
                        .font(.title3)
                    Text(item.description)
                        .lineLimit(2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .animation(.default, value: selectedItem)
        .task {
            tvshows = KodiConnector.shared.media.filter(MediaFilter(media: .tvshow))
        }
    }
}
