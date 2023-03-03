//
//  TVShowsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
    /// Define the grid layout (for tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .tvshows, status: state)
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
        .task(id: selectedTVShow) {
            scene.navigationSubtitle = Router.tvshows.label.title
        }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        ZStack {
            List(selection: $selectedTVShow) {
                ForEach(tvshows) { tvshow in
                    TVShowView.Item(tvshow: tvshow)
                        .tag(tvshow)
                }
            }
            .scaleEffect(selectedTVShow.media == .tvshow ? 0.6 : 1)
            .offset(x: selectedTVShow.media == .tvshow ? -ContentView.columnWidth : 0, y: 0)
            SeasonsView(tvshow: selectedTVShow)
                .transition(.move(edge: .leading))
                .offset(x: selectedTVShow.media == .tvshow ? 0 : ContentView.columnWidth, y: 0)
        }
        .toolbar {
            if selectedTVShow.media == .tvshow {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        /// Deselect the TV show
                        selectedTVShow.media = .none
                        /// We might came from the search page
                        if scene.sidebarSelection == .search {
                            scene.contentSelection = .search
                            scene.details = .tvshows
                        } else {
                            scene.details = .tvshows
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
#endif

#if os(tvOS)
        ScrollView {
            PartsView.DetailHeader(title: Router.tvshows.label.title)
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(tvshows) { tvshow in
                    NavigationLink(value: tvshow, label: {
                        TVShowView.Item(tvshow: tvshow)
                    })
                    .padding(.bottom, 40)
                }
            }
        }
        .buttonStyle(.card)
        .frame(maxWidth: .infinity, alignment: .topLeading)
#endif

    }
}
