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

    case movies
    case movie(movie: Video.Details.Movie)
    case movieSet(movieSet: Video.Details.MovieSet)
    case unwatchedMovies

    /// # TV shows

    case tvshows
    case tvshow(tvshow: Video.Details.TVShow)
    case seasons
    case season(tvshow: Video.Details.TVShow, episodes: [Video.Details.Episode])
    case episode(episode: Video.Details.Episode)
    case unwachedEpisodes

    /// # Music Videos

    case artist(artist: Audio.Details.Artist)
    case musicVideos
    case musicVideo(musicVideo: Video.Details.MusicVideo)
    case album(album: MediaItem)

    /// # Other

    case start
    case search
    case kodiSettings
    case kodiSettingsDetails(section: Setting.Section, category: Setting.Category)

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
        let title: String
        let description: String
        let icon: String
        let route: Router = .start
        var visible: Bool = true
    }

}
