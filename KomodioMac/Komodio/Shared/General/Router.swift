//
//  Router.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Router for Komodio navigation
enum Router: Hashable {

    /// # Movies

    /// All movies
    case movies
    /// A specific movie
    case movie(movie: Video.Details.Movie)
    /// A movie set
    case movieSet(movieSet: Video.Details.MovieSet)
    /// All unwatched movies
    case unwatchedMovies

    /// # TV shows

    /// All TV shows
    case tvshows
    /// A specific TV show
    case tvshow(tvshow: Video.Details.TVShow)
    /// All seasons of a specific TV show
    case seasons(tvhow: Video.Details.TVShow)
    /// A season of a specific TV show
    case season(tvshow: Video.Details.TVShow, episodes: [Video.Details.Episode])
    /// A specific episode
    case episode(episode: Video.Details.Episode)
    /// First unwatched episode of unfinnished TV shows
    case unwachedEpisodes

    /// # Music Videos

    /// A specific artist
    case artist(artist: Audio.Details.Artist)
    /// All music videos
    case musicVideos
    /// A specific music video
    case musicVideo(musicVideo: Video.Details.MusicVideo)
    /// A music video album
    case album(album: MediaItem)

    /// # Other

    /// Start View for Komodio
    case start
    /// The search View
    case search
    /// The Kodi settings View
    case kodiSettings
    /// The Kodi settings details View
    case kodiSettingsDetails(section: Setting.Section, category: Setting.Category)

    /// Message when loading media for a View
    var loading: String {
        switch self {
        case .movies:
            return "Loading your movies..."
        case .tvshows:
            return "Loading your TV shows..."
        case .musicVideos:
            return "Loading your Music Videos..."
        default:
            return "Loading..."
        }
    }

    /// Message when media is empty
    var empty: String {
        switch self {
        case .start:
            return "Loading your library"
        case .musicVideos:
            return "There are no music videos in your library"
        case .search:
            return "Search did not find any results"
        case .movies:
            return "There are no movies in your library"
        case .tvshows:
            return "There are no TV shows in your library"
        case .movieSet:
            return "The movie set is empty"
        case .seasons:
            return "There are no seasons for this TV show"
        case .artist:
            return "This artist is not in your library"
        case .album:
            return "There are no albums for this artist"
        default:
            return "Navigation Error"
        }
    }

    /// The lable of the ``Router`` item
    var label: Item {
        switch self {
        case .start:
            return Item(title: "Komodio",
                        description: "Loading your library",
                        icon: "sparkles.tv"
            )
        case .musicVideos:
            return Item(title: "Music Videos",
                        description: "All the Music Videos in your library",
                        icon: "music.note.tv"
            )
        case .search:
            return Item(title: "Search",
                        description: "Search Results",
                        icon: "magnifyingglass"
            )
        case .movies:
            return Item(title: "All Movies",
                        description: "All the Movies in your Library",
                        icon: "film"
            )
        case .unwatchedMovies:
            return Item(title: "Unwatched Movies",
                        description: "Movies that you have not seen yet",
                        icon: "eye"
            )
        case .tvshows:
            return Item(title: "All TV shows",
                        description: "All the TV shows in your Library",
                        icon: "tv"
            )
        case .unwachedEpisodes:
            return Item(title: "Up Next",
                        description: "Watch the next Episode of a TV show",
                        icon: "eye"
            )
        case .movieSet:
            return Item(title: "Movie Set",
                        description: "The movies in the set",
                        icon: "film"
            )
        case .seasons:
            return Item(title: "Seasons",
                        description: "The seasons in a TV show",
                        icon: "tv"
            )
        case .artist:
            return Item(title: "Artist",
                        description: "An artist",
                        icon: "person"
            )
        case .album:
            return Item(title: "Albums",
                        description: "The albums of the artist",
                        icon: "square.stack"
            )
        case .kodiSettings:
            return Item(title: "Kodi Settings",
                        description: "The Settings for your Kodi",
                        icon: "gear"
            )
        default:
            return Item(title: "Details",
                        description: "Details of an item",
                        icon: "square.dashed"
            )
        }
    }

    /// An item in the sidebar
    struct Item {
        /// Title of the item
        let title: String
        /// Description ofg tghe item
        let description: String
        /// The SF symbol
        let icon: String
        /// The ``Router``
        let route: Router = .start
    }
}
