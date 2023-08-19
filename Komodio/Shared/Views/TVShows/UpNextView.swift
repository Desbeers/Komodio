//
//  UpNextView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Up Next View

/// SwiftUI `View` for next Episode of TV shows that are not completed (shared)
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
    /// The collection in this view
    @State private var collection: [AnyKodiItem] = []
    /// The sorting
    @State private var sorting = SwiftlyKodiAPI.List.Sort(id: "upnext", method: .dateAdded, order: .descending)

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(router: .unwachedEpisodes, status: state)
            }
        }
        .animation(.default, value: episodes)
        .animation(.default, value: state)
        .task(id: kodi.library.episodes) {
            getUnwatchedEpisodes()
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    @ViewBuilder var content: some View {

#if os(macOS)
        ContentView.Wrapper(
            header: {},
            content: {
                CollectionView(
                    collection: $collection,
                    sorting: $sorting,
                    collectionStyle: scene.collectionStyle
                )
            },
            buttons: {}
        )
#endif

#if canImport(UIKit)
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.unwachedEpisodes.item.title,
                    subtitle: Router.unwachedEpisodes.item.description
                )
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    CollectionView(
                        collection: $collection,
                        sorting: $sorting,
                        collectionStyle: .asGrid
                    )
                    .frame(width: StaticSetting.contentWidth, alignment: .leading)
                    .backport.focusSection()
                    DetailView()
                }
            },
            buttons: {}
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

            /// Map the items in collections
            collection = episodes.anykodiItem()
            /// Update the optional selected TV show
            Task { @MainActor in
                if
                    let episode = scene.detailSelection.item.kodiItem as? Video.Details.Episode,
                    let update = episodes.first(where: { $0.tvshowID == episode.tvshowID }),
                    episode.id != update.id {
                    /// Set the new episode
                    scene.detailSelection = .episode(episode: update)
                } else {
                    scene.detailSelection = .unwachedEpisodes
                }
            }
        }
    }
}
