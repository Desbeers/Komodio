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
    /// The subtitle for this View
    var subtitle: String? {
        if let subtitle = selectedItem {
            return subtitle.season == 0 ? "Specials" : "Season \(subtitle.season)"
        }
        return nil
    }
    /// The View
    var body: some View {
        VStack {
            /// Header
            PartsView.Header(title: tvshow.title, subtitle: subtitle)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach($episodes) { $episode in
                        //                    if episode == 0 || (episode > 0 && episodes[episode - 1].season != episodes[episode].season) {
                        //                        Text(episodes[episode].season == 0 ? "Specials" : "Season \(episodes[episode].season)")
                        //                            .padding(.leading)
                        //                            .frame(maxWidth: .infinity, alignment: .leading)
                        //                            .macOS { $0.font(.title) }
                        //                            .tvOS { $0.font(.title3).padding(.top) }
                        //                    }
                        NavigationLink(destination: DetailsView(item: $episode)) {
                            VStack {
                                ArtView.Poster(item: episode)
                                Text(episode.title)
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: episode)
                        .zIndex(tvshow == selectedItem ? 2 : 1)
                    }
                }
            }
        }
        .background(ArtView.SelectionBackground(item: tvshow))
        .task {
            episodes = KodiConnector.shared.media.filter(MediaFilter(media: .episode, tvshowID: tvshow.tvshowID))
        }
    }
}

