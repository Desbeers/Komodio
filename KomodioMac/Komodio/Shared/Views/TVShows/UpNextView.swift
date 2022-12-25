//
//  UpNextView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for next Episode of TV shows that are not completed
struct UpNextView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The Episodes in this view
    @State var episodes: [Video.Details.Episode] = []
    /// The optional selected Episode
    @State var selectedEpisode: Video.Details.Episode?
    /// The loading state of the view
    @State private var state: Parts.State = .loading
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
                state = .ready
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

    // MARK: Content of the UpNextView

#if os(macOS)
    /// The content of the view
    var content: some View {
        List(selection: $selectedEpisode) {
            ForEach(episodes) { episode in
                Item(episode: episode)
                    .tag(episode)
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
    }
#endif

#if os(tvOS)
    /// The content of the view
    var content: some View {
        HStack {
            List {
                ForEach(episodes) { episode in
                    Button(action: {
                        selectedEpisode = episode
                    }, label: {
                        Item(episode: episode)
                            .foregroundColor(episode == selectedEpisode ? .blue : .primary)
                    })
                }
            }
            .frame(width: 500)
            DetailView()
        }
        .setSafeAreas()
    }
#endif
}

// MARK: Extensions

extension UpNextView {

    /// SwiftUI View for an item in ``UpNextView``
    struct Item: View {
        let episode: Video.Details.Episode
        var body: some View {
            HStack {
                KodiArt.Poster(item: episode)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                VStack(alignment: .leading) {
                    Text(episode.showTitle)
                        .font(.headline)
                    Text(episode.title)
                    Text("Season \(episode.season), episode \(episode.episode)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .watchStatus(of: episode)
            }
        }
    }
}
