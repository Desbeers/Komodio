//
//  UpNextView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                Parts.StatusMessage(item: .unwachedEpisodes, status: state)
            }
        }
        .animation(.default, value: selectedEpisode)
        .task(id: kodi.library.episodes) {
            if kodi.state != .loadedLibrary {
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
                    if let selection = episodes.first(where: {$0.tvshowID == selectedEpisode.tvshowID}) {
                        self.selectedEpisode = selection
                    } else {
                        self.selectedEpisode = nil
                        scene.details = .unwachedEpisodes
                    }
                }
            }
        }
        .task(id: selectedEpisode) {
            if let selectedEpisode {
                scene.details = .episode(episode: selectedEpisode)
            } else {
                scene.navigationSubtitle = Router.unwachedEpisodes.label.title
            }
        }
    }

    // MARK: Content of the View

    /// The content of the view
    @ViewBuilder var content: some View {

#if os(macOS)
        List(selection: $selectedEpisode) {
            ForEach(episodes) { episode in
                Item(episode: episode)
                    .tag(episode)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
#endif

#if os(tvOS)
        HStack {
            List {
                ForEach(episodes) { episode in
                    Button(action: {
                        selectedEpisode = episode
                    }, label: {
                        Item(episode: episode)
                            .foregroundColor(episode == selectedEpisode ? Color("AccentColor") : .primary)
                    })
                }
            }
            .frame(width: 500)
            .buttonStyle(.card)
            DetailView()
                .frame(maxWidth: .infinity)
                .focusSection()
        }
        .setSafeAreas()
#endif

    }
}

// MARK: Extensions

extension UpNextView {

    /// SwiftUI View for an item in ``UpNextView``
    struct Item: View {
        /// The Episode
        let episode: Video.Details.Episode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Poster(item: episode)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(episode.showTitle)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(episode.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("Season \(episode.season), episode \(episode.episode)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
    }
}
