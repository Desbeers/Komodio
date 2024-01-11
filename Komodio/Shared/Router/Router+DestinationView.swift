//
//  Router+DestinationView.swift
//  Komodio
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
            case .appSettings:
                SettingsView()
            case .kodiSettings:
                KodiSettingsView()
            case .hostItemSettings(let host):
                HostItemView(host: host)

                // MARK: Movies

            case .movies:
                MoviesView()
            case .movie(let movie):
                MovieView
                    .Details(movie: movie)
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
                    .id(file)

                // MARK: TV shows

            case .tvshows:
                TVShowsView()
            case .tvshow(let tvshow):
                SeasonsView(tvshow: tvshow)
            case .season(let season):
                SeasonView
                    .Details(season: season)
            case .episode(let episode):
                EpisodeView
                    .Details(episode: episode)
            case .unwachedEpisodes:
                UpNextView()

                // MARK: Music Videos

            case .musicVideoArtist(let artist):
                MusicVideosView(artist: artist)
            case .musicVideos:
                ArtistsView()
            case .musicVideo(let musicVideo):
                MusicVideoView
                    .Details(musicVideo: musicVideo)
            case .musicVideoAlbum(let musicVideoAlbum):
                MusicVideoAlbumView
                    .Details(musicVideoAlbum: musicVideoAlbum)

                // MARK: Fallback

            default:
                Text("Not implemented")
            }
        }
    }
}
