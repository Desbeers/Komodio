//
//  DetailView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Detail View

/// SwiftUI `View` for details of the selection (shared)
struct DetailView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The current detail selection
    @State private var selection: Router = .fallback

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch selection {
            case .start:
                Color.clear
            case .movie(let movie):
                MovieView
                    .Details(movie: movie)
            case .movieSet(let movieSet):
                MovieSetView
                    .Details(movieSet: movieSet)
            case .tvshow(let tvshow):
                TVShowView
                    .Details(tvshow: tvshow)
            case .episode(let episode):
                EpisodeView
                    .Details(episode: episode)
            case .season(let season):
                SeasonView
                    .Details(season: season)
            case .musicVideoArtist(let artist):
                ArtistView
                    .Details(artist: artist)
            case .musicVideo(let musicVideo):
                MusicVideoView
                    .Details(musicVideo: musicVideo)
            case .musicVideoAlbum(let musicVideoAlbum):
                MusicVideoAlbumView
                    .Details(musicVideoAlbum: musicVideoAlbum)
            case .appSettings:
                HostItemView
                    .Details()
            case .kodiSettings:
                KodiSettingsView
                    .Details()
            case .hostItemSettings(let host):
                HostItemView(host: host)
            case .fallback:
                Color.clear
            default:
                fallback
            }
        }
        .animation(.default, value: selection)
        .task(id: scene.detailSelection) {
            selection = scene.detailSelection
        }
    }

    // MARK: Fallback of the View

    /// The fallback View
    @ViewBuilder private var fallback: some View {
#if os(macOS)
        DetailView.Wrapper(
            scroll: nil,
            title: selection.item.title,
            subtitle: selection.item.description
        ) {
            fallbackIcon
        }
#endif

#if os(tvOS) || os(iOS) || os(visionOS)
        fallbackIcon
#endif
    }

    /// The fallback icon
    @ViewBuilder private var fallbackIcon: some View {
        Image(systemName: selection.item.icon)
            .resizable()
            .scaledToFit()
            .padding(80)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .transition(.move(edge: .trailing))
        /// - Note: Give it an ID to trigger the transition
            .id(selection.item.icon)
    }
}
