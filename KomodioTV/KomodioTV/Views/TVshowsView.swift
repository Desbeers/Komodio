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
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The tv shows to show
    @State private var tvshows: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// Hide watched
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The View
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Button(action: {
                    hideWatched.toggle()
                }, label: {
                    Text(hideWatched ? "Show all shows" : "Hide watched shows")
                        .padding()
                })
                .buttonStyle(.card)
                /// Don't animate the button
                .transaction { transaction in
                    transaction.animation = nil
                }
                Text("\(tvshows.count)" + (hideWatched ? " unwatched" : "") + " shows")
                    .font(.caption)
                    .foregroundColor(.secondary)
                /// Show selected item info
                if let item = selectedItem {
                    VStack {
                        Text(item.title)
                            .font(.headline)
                        Text(item.details)
                            .font(.caption)
                        Divider()
                        Text(item.description)
                        /// If the item is a set; list all movies that is part of this set
                        if item.movieSetID != 0 {
                            ForEach(KodiConnector.shared.media.filter { $0.media == .movie && $0.movieSetID == item.movieSetID}) { movie in
                                Label(movie.title, systemImage: "film")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
            .frame(width: 500)
            .focusSection()
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach($tvshows) { $tvshow in
                        NavigationLink(destination: EpisodesView(tvshow: tvshow)) {
                            ArtView.Poster(item: tvshow)
                                .watchStatus(of: $tvshow)
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: tvshow)
                        .itemContextMenu(for: $tvshow)
                        .zIndex(tvshow == selectedItem ? 2 : 1)
                    }
                }
                /// Don't animate the grid; posters will 'fly'...
                .transaction { transaction in
                    transaction.animation = nil
                }
            }
        }
        //.background(ArtView.SelectionBackground(item: selectedItem))
        .animation(.default, value: selectedItem)
        .task {
            tvshows = getTVshows()
        }
        .onChange(of: hideWatched) { _ in
            tvshows = getTVshows()
        }
        .onChange(of: selectedItem) { item in
            appState.selection = item
        }
    }
    
    /// Get the list of tv shows
    /// - Returns: All TV shows, optional filtered by watched state
    private func getTVshows() -> [MediaItem] {
        return KodiConnector.shared.media.filter(MediaFilter(media: .tvshow)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
    }
}
