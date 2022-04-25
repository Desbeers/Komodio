//
//  EpisodesView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 25/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct EpisodesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The TV show item in the library
    let tvshow: MediaItem
    /// The Episode items to show in this view
    @State private var episodes: [MediaItem] = []
    /// The focused item
    @FocusState var selectedItem: MediaItem?
//    /// Init the View
//    init(tvshow: MediaItem) {
//        self.tvshow = tvshow
//        self.episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
//    }
    /// The View
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(episodes.indices, id: \.self) { episode in
//                    if episode == 0 || (episode > 0 && episodes[episode - 1].season != episodes[episode].season) {
//                        Text(episodes[episode].season == 0 ? "Specials" : "Season \(episodes[episode].season)")
//                            .padding(.leading)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .macOS { $0.font(.title) }
//                            .tvOS { $0.font(.title3).padding(.top) }
//                    }
                    NavigationLink(destination: DetailsView(item: episodes[episode])) {
                        ArtView.Poster(item: episodes[episode])
                    }
                    .buttonStyle(.card)
                    .padding()
                    .focused($selectedItem, equals: tvshow)
                    .zIndex(tvshow == selectedItem ? 2 : 1)
                }
            }
        }
        .navigationTitle(tvshow.title)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ArtView.Background(fanart: tvshow.fanart).opacity(0.3))
        .ignoresSafeArea()
        .task {
            episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
        }
    }
}

