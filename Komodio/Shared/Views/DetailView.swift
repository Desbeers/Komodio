//
//  DetailView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
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

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            switch scene.detailSelection {
            case .start:
                StartView
                    .Details()
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
            case .kodiSettings:
                KodiSettingsView
                    .Details()
            case .hostItemSettings:
                HostItemView
                    .Details()
            default:
                fallback
            }
        }
        .animation(.default, value: scene.detailSelection)
    }

    // MARK: Fallback of the View

    /// The fallback View
    @ViewBuilder private var fallback: some View {
#if os(macOS)
        DetailView.Wrapper(
            scroll: nil,
            title: scene.mainSelection.item.title,
            subtitle: scene.mainSelection.item.description
        ) {
            fallbackIcon
        }
#endif

#if os(tvOS) || os(iOS)
        fallbackIcon
#endif
    }

    /// The fallback icon
    @ViewBuilder private var fallbackIcon: some View {
        Image(systemName: scene.mainSelection.item.icon)
            .resizable()
            .scaledToFit()
            .padding(80)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
