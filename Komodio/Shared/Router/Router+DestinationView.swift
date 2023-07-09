//
//  Router+DestinationView.swift
//  Komodio
//
//  Created by Nick Berendsen on 01/07/2023.
//

import SwiftUI

extension Router {

    /// SwiftUI `View`with a `Router` destination in the `ContentView`
    struct DestinationView: View {
        /// The `Router` item
        let router: Router
        /// The body of the `View`
        var body: some View {
            switch router {

                // MARK: General

            case .start:
                StartView()
            case .favourites:
                FavouritesView()
            case .search:
                SearchView()
            case .kodiSettings:
                KodiSettingsView()
            case .hostItemSettings(let host):
                HostItemView(host: host)

                // MARK: Movies

            case .movies:
                MoviesView()
            case .movie:
                DetailView()
            case .movieSet(let movieSet):
                MovieSetView(movieSet: movieSet)
            case .unwatchedMovies:
                MoviesView(filter: .unwatched)
#if os(tvOS)
            case .moviePlaylists:
                PlaylistsView()
#endif
            case .moviePlaylist(let file):
                MoviesView(filter: .playlist(file: file))

                // MARK: TV shows

            case .tvshows:
                TVShowsView()
            case .tvshow(let tvshow):
                SeasonsView(tvshow: tvshow)
            case .seasons:
                DetailView()
            case .season(let season):
                SeasonView.Details(season: season)
            case .episode(let episode):
                EpisodeView.Details(episode: episode)
            case .unwachedEpisodes:
                UpNextView()

                // MARK: Music Videos

            case .musicVideoArtist(let artist):
                MusicVideosView(artist: artist)
            case .musicVideos:
                ArtistsView()
            case .musicVideo(let musicVideo):
                MusicVideoView.Details(musicVideo: musicVideo)
            case .musicVideoAlbum(let musicVideos):
                AlbumView.Details(musicVideos: musicVideos)

                // MARK: Fallback

            default:
                Text("Not implemented")
            }
        }
    }
}
