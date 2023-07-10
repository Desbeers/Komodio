//
//  Router.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Router for Komodio navigation (shared)
enum Router: Hashable {

    // MARK: General

    /// Start View for Komodio
    case start
    /// Favourites
    case favourites
    /// The search View
    case search
    /// The Kodi settings View
    case kodiSettings
    /// Kodi Host connection settings
    case hostItemSettings(host: HostItem)
    /// Fallback
    case fallback

    // MARK: Movies

    /// All movies
    case movies
    /// A specific movie
    case movie(movie: Video.Details.Movie)
    /// A movie set
    case movieSet(movieSet: Video.Details.MovieSet)
    /// All unwatched movies
    case unwatchedMovies
    /// All movie playlists
    case moviePlaylists
    /// A specific movie playlist
    case moviePlaylist(file: SwiftlyKodiAPI.List.Item.File)

    // MARK: TV shows

    /// All TV shows
    case tvshows
    /// A specific TV show
    case tvshow(tvshow: Video.Details.TVShow)
    /// All seasons of a specific TV show
    case seasons(tvshow: Video.Details.TVShow)
    /// A season of a specific TV show
    case season(season: Video.Details.Season)
    /// A specific episode
    case episode(episode: Video.Details.Episode)
    /// First unwatched episode of unfinnished TV shows
    case unwachedEpisodes

    // MARK: Music Videos

    /// A specific artist
    case musicVideoArtist(artist: Audio.Details.Artist)
    /// All music videos
    case musicVideos
    /// A specific music video
    case musicVideo(musicVideo: Video.Details.MusicVideo)
    /// A music video album
    case musicVideoAlbum(musicVideoAlbum: Video.Details.MusicVideoAlbum)
}
