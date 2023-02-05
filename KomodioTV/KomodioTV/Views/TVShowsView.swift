//
//  TVShowsView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'TV shows' SwiftUI View
struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show; loaded by a 'Task'.
    @State private var tvshows: [Video.Details.TVShow] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The loading state of the view
    @State private var state: Parts.State = .loading
    /// The body of this View
    var body: some View {
        VStack {
            switch state {
            case .loading:
                Text("Loading your shows")
            case .empty:
                Text("There are no shows in your library")
            case .ready:
                content
            case .offline:
                state.offlineMessage
            }
        }
        .animation(.default, value: hideWatched)
        .task(id: kodi.library.tvshows) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.tvshows.isEmpty {
                state = .empty
            } else {
                tvshows = kodi.library.tvshows
                state = .ready
            }
        }
    }
    /// The content of this View
    var content: some View {
        ScrollView {
            Button(action: {
                hideWatched.toggle()
            }, label: {
                Text(hideWatched ? "Show all shows" : "Hide watched shows")
                    .frame(width: 400)
                    .padding()
            })
            .buttonStyle(.card)
            .padding()
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(tvshows.filter { $0.playcount < (hideWatched ? 1 : 1000) }) { tvshow in
                    Item(tvshow: tvshow)
                    .buttonStyle(.card)
                    /// - Note: Context Menu must go after the Button Style or else it does not work...
                    .contextMenu(for: tvshow)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

extension TVShowsView {
    
    struct Item: View {
        let tvshow: Video.Details.TVShow
        var body: some View {
            NavigationLink(destination: EpisodesView(tvshow: tvshow)) {
                KodiArt.Poster(item: tvshow)
                    .scaledToFill()
                    .frame(width: 300, height: 450)
                    .watchStatus(of: tvshow)
            }
        }
    }
}
