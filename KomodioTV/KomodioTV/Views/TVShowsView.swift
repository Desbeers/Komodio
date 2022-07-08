//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A SwiftUI View for TV show items
struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show; loaded by a 'Task'.
    @State private var tvshows: [Video.Details.TVShow] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    //@FocusState private var selectedItem: MediaItem?
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The body of this View
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(tvshows) { tvshow in
                        TVShowItem(tvshow: tvshow)
                        .buttonStyle(.card)
                        /// - Note: Context Menu must go after the Button Style or else it does not work...
                        .contextMenu(for: tvshow)
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
    }
}

extension TVShowsView {
    
    struct TVShowItem: View {
        let tvshow: Video.Details.TVShow
        var body: some View {
            NavigationLink(destination: EpisodesView(tvshow: tvshow)) {
                KodiArt.Poster(item: tvshow)
                    .frame(width: 300, height: 450)
                    .watchStatus(of: tvshow)
            }
        }
    }
}
