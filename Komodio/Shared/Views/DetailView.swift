//
//  DetailView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Detail View

/// SwiftUI View for details of the selection (shared)
struct DetailView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch scene.details {
            case .start:
                StartView.Details()
            case .movie(let movie):
                MovieView
                    .Details(movie: movie)
                    .id(movie.id)
            case .movieSet(let movieSet):
                MovieSetView
                    .Details(movieSet: movieSet)
                    .id(movieSet.id)
            case .tvshow(let tvshow):
                TVShowView
                    .Details(tvshow: tvshow)
            case .episode(let episode):
                UpNextView
                    .Details(episode: episode)
                    .id(episode.id)
            case let .season(tvshow, episodes):
                SeasonView(tvshow: tvshow, episodes: episodes)
            case .musicVideoArtist(let artist):
                ArtistView
                    .Details(artist: artist)
            case .musicVideo(let musicVideo):
                MusicVideoView
                    .Details(musicVideo: musicVideo)
                    .id(musicVideo.id)
            case .musicVideoAlbum(let musicVideos):
                AlbumView(musicVideos: musicVideos)
            case .kodiSettings:
                KodiSettingsView
                    .Details()
            case .hostItemSettings:
                HostItemView
                    .KodiSettings()
            default:
                fallback
            }
        }
        .animation(.default, value: scene.details)
    }

    // MARK: Fallback of the View

    /// The fallback View
    @ViewBuilder private var fallback: some View {
#if os(macOS)
        DetailView.Wrapper(
            title: scene.mainSelection.item.title,
            subtitle: scene.mainSelection.item.description
        ) {
            Image(systemName: scene.mainSelection.item.icon)
                .resizable()
                .scaledToFit()
                .padding(80)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
#endif

#if os(tvOS) || os(iOS)
        Image(systemName: scene.mainSelection.item.icon)
            .resizable()
            .scaledToFit()
            .padding(80)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
#endif
    }
}
