//
//  DetailView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
                MovieSetView.Details(movieSet: movieSet)
            case .tvshow(let tvshow):
                TVShowView.Details(tvshow: tvshow).id(tvshow.id)
            case .episode(let episode):
                EpisodeView.Item(episode: episode).id(episode.tvshowID)
            case .season(let tvshow, let episodes):
                SeasonView(tvshow: tvshow, episodes: episodes)
            case .artist(let artist):
                ArtistView.Details(artist: artist)
            case .musicVideo(let musicVideo):
                MusicVideoView
                    .Details(musicVideo: musicVideo)
                    .id(musicVideo.id)
            case .album(let musicVideos):
                AlbumView(musicVideos: musicVideos)
            case .kodiSettingsDetails(let section, let category):
                KodiSettingsView.Details(section: section, category: category)
            case .kodiHostSettings(let host):
                KodiHostView.Details(host: host).id(host.ip)
            default:
                fallback
            }
        }
        .animation(.default, value: scene.details)
    }

    // MARK: Fallback of the View

    /// The fallback View
    private var fallback: some View {
        VStack {
            Parts.DetailMessage(title: scene.sidebarSelection.label.title, message: scene.sidebarSelection.label.description)
            Image(systemName: scene.sidebarSelection.label.icon)
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
