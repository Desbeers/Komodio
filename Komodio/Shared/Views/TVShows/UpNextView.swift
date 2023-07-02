//
//  UpNextView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Up Next View

/// SwiftUI View for next Episode of TV shows that are not completed (shared)
struct UpNextView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The Episodes in this view
    @State private var episodes: [Video.Details.Episode] = []
    /// The optional selected Episode
    @State private var selectedEpisode: Video.Details.Episode?
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// The opacity of the View
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .unwachedEpisodes, status: state)
            }
        }
        .task(id: kodi.library.episodes) {
            getUnwatchedEpisodes()
        }
    }

    // MARK: Content of the View

    /// The content of the view
    @ViewBuilder var content: some View {

#if os(macOS)
        ScrollView {
            LazyVStack {
                ForEach(episodes) { episode in
                    Button(
                        action: {
                            selectedEpisode = episode
                            scene.details = .episode(episode: episode)
                        },
                        label: {
                            Item(episode: episode)
                        }
                    )
                    .buttonStyle(.listButton(selected: selectedEpisode?.id == episode.id))
                    Divider()
                }
            }
            .padding()
        }
        .opacity(opacity)
        .animation(.default, value: opacity)
#endif

#if os(tvOS)
        ContentView.Wrapper(
            scroll: false,
            header: {
                PartsView.DetailHeader(
                    title: Router.unwachedEpisodes.item.title,
                    subtitle: Router.unwachedEpisodes.item.description
                )
            },
            content: {
                HStack(spacing: 0) {
                    List {
                        ForEach(episodes) { episode in
                            Button(action: {
                                selectedEpisode = episode
                            }, label: {
                                Item(episode: episode)
                            })
                        }
                    }
                    .frame(width: KomodioApp.posterSize.width * 1.5, alignment: .center)
                    .backport.cardButton()
                    if let selectedEpisode {
                        Details(episode: selectedEpisode)
                            .padding(.trailing, KomodioApp.posterSize.width * 0.3)
                            .backport.focusSection()
                    } else {
                        DetailView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, KomodioApp.posterSize.width * 0.3)
            }
        )
        .animation(.default, value: selectedEpisode)
#endif

#if os(iOS)
        ContentView.Wrapper(
            scroll: true,
            header: {
                PartsView.DetailHeader(
                    title: Router.unwachedEpisodes.item.title,
                    subtitle: Router.unwachedEpisodes.item.description
                )
            },
            content: {
                LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                    ForEach(episodes) { episode in
                        NavigationLink(value: Router.episode(episode: episode)) {
                            Item(episode: episode)
                                .padding(.bottom, KomodioApp.posterSize.height / 9)
                        }
                    }
                }
                .backport.cardButton()
            }
        )
#endif
    }

    // MARK: Private functions

    /// Get all movies from the selected set
    private func getUnwatchedEpisodes() {
        opacity = 1
        if kodi.status != .loadedLibrary {
            state = .offline
        } else if kodi.library.tvshows.isEmpty {
            state = .empty
        } else {
            episodes = Array(kodi.library.episodes
                .filter { $0.playcount == 0 && $0.season != 0 }
                .sorted { $0.firstAired < $1.firstAired }
                .unique { $0.tvshowID }
                .sorted { $0.dateAdded > $1.dateAdded }
            )
            state = episodes.isEmpty ? .empty : .ready
            /// Update the optional selected item
            if let selectedEpisode {
                if let selection = episodes.first(where: { $0.tvshowID == selectedEpisode.tvshowID }) {
                    self.selectedEpisode = selection
                    scene.details = .episode(episode: selection)
                } else {
                    self.selectedEpisode = nil
                    scene.details = .unwachedEpisodes
                }
            }
        }
    }
}
