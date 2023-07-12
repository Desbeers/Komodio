//
//  Router+Item.swift
//  Komodio
//
//  Created by Nick Berendsen on 01/07/2023.
//

import SwiftUI
import SwiftlyKodiAPI

extension Router {

    /// Structure for a ``Router`` Item
    struct Item {
        /// Title of the item
        var title: String = "Title"
        /// Description of the item
        var description: String = "Description"
        /// Loading message of the item
        var loading: String = "Loading"
        /// Message when the item is empty
        var empty: String = "Empty"
        /// The SF symbol for the item
        var icon: String = "square.dashed"
        /// The color of the item
        var color: Color = Color("AccentColor")
        /// The optional KodiItem
        var kodiItem: (any KodiItem)?
    }
}

extension Router {

    /// Details f the router item
    var item: Item {
        switch self {

            // MARK: General

        case .start:
            return Item(
                title: "Komodio",
                description: "Welcome to Komodio",
                loading: "Connecting",
                empty: "Not connected",
                icon: "sparkles.tv",
                color: Color("AccentColor")
            )
        case .favourites:
            return Item(
                title: "Favourites",
                description: "Your favourite items",
                loading: "Loading your favourite items",
                empty: "You have no favourite items",
                icon: "heart.fill",
                color: Color("DarkRed")
            )
        case .search:
            return Item(
                title: "Search",
                description: "Search your library",
                loading: "Searching your library",
                empty: "No items found",
                icon: "magnifyingglass",
                color: Color("AccentColor")
            )
        case .kodiSettings:
            return Item(
                title: "Kodi settings",
                description: "The settings on your host",
                loading: "Loading your settings",
                empty: "There are no settings",
                icon: "gear",
                color: Color("AccentColor")
            )
        case .hostItemSettings(let host):
            return Item(
                title: "Host settings",
                description: "Settings for `\(host.name)`",
                loading: "Loading your settings",
                empty: "There are no settings",
                icon: "gear",
                color: Color("AccentColor")
            )

            // MARK: Movies

        case .movies:
            return Item(
                title: "All Movies",
                description: "All the Movies in your Library",
                loading: "Loading your Movies",
                empty: "There are no Movies in your Library",
                icon: "film",
                color: .teal
            )
        case .movie(let movie):
            return Item(
                title: "\(movie.title)",
                description: "\(movie.subtitle)",
                loading: "Loading `\(movie.title)`",
                empty: "`\(movie.title)` was not found",
                icon: "film",
                color: .teal,
                kodiItem: movie
            )
        case .movieSet(let movieSet):
            return Item(
                title: "\(movieSet.title)",
                description: "\(movieSet.subtitle)",
                loading: "Loading `\(movieSet.title)`",
                empty: "`\(movieSet.title)` was not found",
                icon: "circle.grid.cross.fill",
                color: .teal,
                kodiItem: movieSet
            )
        case .unwatchedMovies:
            return Item(
                title: "Unwatched Movies",
                description: "Movies you have not seen yet",
                loading: "Loading your Unwatched Movies",
                empty: "You have no Unwatched Movies in your library",
                icon: "eye",
                color: .teal
            )
        case .moviePlaylists:
            return Item(
                title: "Movie Playlists",
                description: "All your Movie Playlists",
                loading: "Loading your Movie Playlists",
                empty: "You have no Movie Playlists in your library",
                icon: "list.triangle",
                color: .purple
            )
        case .moviePlaylist(let file):
            return Item(
                title: "\(file.label)",
                description: "Movie playlist",
                loading: "Connecting",
                empty: "Not connected",
                icon: "list.triangle",
                color: .purple
            )

            // MARK: TV shows

        case .tvshows:
            return Item(
                title: "All TV shows",
                description: "All the TV shows in your Library",
                loading: "Loading your TV shows",
                empty: "There are no TV shows in your Library",
                icon: "tv",
                color: .indigo
            )
        case .tvshow(let tvshow):
            return Item(
                title: "\(tvshow.title)",
                description: "\(tvshow.subtitle)",
                loading: "Loading `\(tvshow.title)`",
                empty: "`\(tvshow.title)` was not found",
                icon: "tv",
                color: .indigo,
                kodiItem: tvshow
            )
        case .seasons(let tvshow):
            return Item(
                title: "All Seasons",
                description: "All the Seasons from `\(tvshow.title)`",
                loading: "Loading your Seasons",
                empty: "There are no Seasons for `\(tvshow.title)` in your Library",
                icon: "tv",
                color: .indigo,
                kodiItem: tvshow
            )
        case .season(let season):
            return Item(
                title: "\(season.title)",
                description: "All the Episodes from Season \(season.season)",
                loading: "Loading your Episodes",
                empty: "There are no Episodes in Season \(season.season)",
                icon: "tv",
                color: .indigo,
                kodiItem: season
            )
        case .episode(let episode):
            return Item(
                title: "\(episode.title)",
                description: "\(episode.subtitle)",
                loading: "Loading `\(episode.title)`",
                empty: "`\(episode.title)` was not found",
                icon: "tv",
                color: .indigo,
                kodiItem: episode
            )
        case .unwachedEpisodes:
            return Item(
                title: "Up Next",
                description: "Watch the next Episode of a TV show",
                loading: "Loading your Episodes",
                empty: "There are no new Episodes in your Library",
                icon: "eye",
                color: .indigo
            )

            // MARK: Music Videos

        case .musicVideoArtist(let artist):
            return Item(
                title: "\(artist.title)",
                description: "\(artist.subtitle)",
                loading: "Loading `\(artist.title)`",
                empty: "`\(artist.title)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: artist
            )
        case .musicVideos:
            return Item(
                title: "All Music Videos",
                description: "All the Music Videos in your Library",
                loading: "Loading your Music Videos",
                empty: "There are no Music Videos in your Library",
                icon: "music.note.tv",
                color: .cyan
            )
        case .musicVideo(let musicVideo):
            return Item(
                title: "\(musicVideo.title)",
                description: "\(musicVideo.subtitle)",
                loading: "Loading `\(musicVideo.title)`",
                empty: "`\(musicVideo.title)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: musicVideo
            )
        case .musicVideoAlbum(let musicVideoAlbum):
            return Item(
                title: "\(musicVideoAlbum.album)",
                description: "All Music Videos from `\(musicVideoAlbum.album)`",
                loading: "Loading `\(musicVideoAlbum.album)`",
                empty: "`\(musicVideoAlbum.album)` was not found",
                icon: "music.note.tv",
                color: .cyan,
                kodiItem: musicVideoAlbum
            )

            // MARK: Fallback

        default:
            return Item()
        }
    }
}
