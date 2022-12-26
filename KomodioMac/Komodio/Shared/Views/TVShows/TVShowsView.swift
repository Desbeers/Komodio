//
//  TVShowsView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all TV shows
struct TVShowsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The TV shows in this view
    @State var tvshows: [Video.Details.TVShow] = []
    /// The optional selected TV show
    @State var selectedTVShow = Video.Details.TVShow(media: .none)
    /// The loading state of the view
    @State private var state: Parts.State = .loading

    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 260))]

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .loading:
                Text(Router.tvshows.loading)
            case .empty:
                Text(Router.tvshows.empty)
            case .ready:
                content
            case .offline:
                state.offlineMessage
            }
        }
        .animation(.default, value: selectedTVShow)
        .task(id: kodi.library.tvshows) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.tvshows.isEmpty {
                state = .empty
            } else {
                tvshows = kodi.library.tvshows
                state = .ready
            }
        }
        .task(id: selectedTVShow) {
            if selectedTVShow.media == .tvshow {
                scene.details = .tvshow(tvshow: selectedTVShow)
            } else {
                scene.navigationSubtitle = Router.tvshows.label.title
            }
        }
    }
#if os(macOS)
    /// The content of the view
    var content: some View {
        ZStack {
            List(selection: $selectedTVShow) {
                ForEach(tvshows) { tvshow in
                    Item(tvshow: tvshow)
                        .tag(tvshow)
                }
            }
            .scaleEffect(selectedTVShow.media == .tvshow ? 0.6 : 1)
            .offset(x: selectedTVShow.media == .tvshow ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
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
    }
#endif
#if os(tvOS)
    /// The content of the view
    var content: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(tvshows) { tvshow in
                    NavigationLink(value: tvshow, label: {
                        Item(tvshow: tvshow)
                    })
                    .padding(.bottom, 40)
                }
            }
        }
        .buttonStyle(.card)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .setSafeAreas()
    }
#endif
}

extension TVShowsView {

    struct Item: View {
        let tvshow: Video.Details.TVShow
        var body: some View {
            HStack {
                KodiArt.Poster(item: tvshow)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: tvshow)
#if os(macOS)
                VStack(alignment: .leading) {
                    Text(tvshow.title)
                        .font(.headline)
                    Text(tvshow.genre.joined(separator: "∙"))
                    Text(tvshow.year.description)
                        .font(.caption)
                }
#endif
            }
        }
    }
}
