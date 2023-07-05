//
//  TVShowsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: TV shows View

/// SwiftUI View for all TV shows (shared)
struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The TV shows in this view
    @State var tvshows: [Video.Details.TVShow] = []
    /// The optional selected TV show (for macOS)
    @State var selectedTVShow = Video.Details.TVShow(media: .none)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .tvshows, status: state)
            }
        }
        .animation(.default, value: selectedTVShow)
        .task(id: kodi.library.tvshows) {
            if kodi.status != .loadedLibrary {
                state = .offline
            } else if kodi.library.tvshows.isEmpty {
                state = .empty
            } else {
                tvshows = kodi.library.tvshows.sorted(using: KeyPathComparator(\.sortByTitle))
                state = .ready
            }
        }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        ScrollView {
            LazyVStack {
                ForEach(tvshows) { tvshow in
                    NavigationLink(value: Router.tvshow(tvshow: tvshow)) {
                        TVShowView.Item(tvshow: tvshow)
                    }
                    .buttonStyle(.kodiItemButton(kodiItem: tvshow))
                    Divider()
                }
            }
            .padding()
        }
#endif

#if os(tvOS) || os(iOS)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.tvshows.item.title,
                    subtitle: Router.tvshows.item.description
                )
            },
            content: {
                LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                    ForEach(tvshows) { tvshow in
                        NavigationLink(value: Router.tvshow(tvshow: tvshow)) {
                            TVShowView.Item(tvshow: tvshow)
                        }
                        .padding(.bottom, KomodioApp.posterSize.height / 9)
                    }
                }
            })
        .backport.cardButton()
        .frame(maxWidth: .infinity, alignment: .topLeading)
#endif
    }
}
