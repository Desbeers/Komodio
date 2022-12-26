//
//  DetailView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for details of the selection
struct DetailView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The Navigation Subtitle
    @State private var navigationSubtitle: String = "hallo"
    /// The body of the View
    var body: some View {
        VStack {
            switch scene.details {
            case .movie(let movie):
                MovieView.Details(movie: movie).id(movie.id)
            case .movieSet(let movieSet):
                MovieSetView.Details(movieSet: movieSet)
            case .tvshow(let tvshow):
                TVShowView(tvshow: tvshow)
            case .episode(let episode):
                EpisodeView(episode: episode)
            case .season(let tvshow, let episodes):
                SeasonView(tvshow: tvshow, episodes: episodes)
            case .artist(let artist):
                ArtistView(artist: artist)
            case .musicVideo(let musicVideo):
                MusicVideoView(musicVideo: musicVideo)
            case .album(let album):
                AlbumView(title: album.id, musicVideos: album.musicVideos ?? [])
#if os(macOS)
            case .kodiSettingsDetails(let section, let category):
                KodiSettingsView.Details(section: section, category: category)
#endif
            default:
                fallback
            }
        }
        .animation(.default, value: scene.details)
        .animation(.default, value: scene.sidebarSelection)
    }
    /// The fallback view
    private var fallback: some View {
        VStack {
            switch scene.sidebarSelection {
            case .start:
                EmptyView()
                //            case .search:
                //                SearchView.Details()
                //            case .kodiSettings:
                //                KodiSettings.Details()
            default:
                Parts.DetailMessage(title: scene.sidebarSelection.label.title, message: scene.sidebarSelection.label.description)
            }
            //            Image(systemName: scene.sidebar.label.icon)
            //                .resizable()
            //                .scaledToFit()
            //                .shadow(radius: 10, x: 10, y: 10)
            //                .opacity(0.1)
            //                .padding(40)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Image(systemName: scene.sidebarSelection.label.icon)
                .resizable()
                .scaledToFit()
                .padding(40)
                .opacity(0.1)
        }
    }
}
