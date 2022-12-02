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
    case start
    case library
    case recentlyAdded
    case mostPlayed
    case recentlyPlayed
    case favorites
    case playingQueue
    case playlist(file: List.Item.File)
    
    case search
    case musicMatch
    
    case movies
    
    case tvshows
    case seasons
    case musicVideos

    case movie(movie: Video.Details.Movie)
    case movieSet(movieSet: Video.Details.MovieSet)
    case tvshow(tvshow: Video.Details.TVShow)
    case season(tvshow: Video.Details.TVShow, episodes: [Video.Details.Episode])
    
    case artist(artist: Audio.Details.Artist)
    case musicVideo(musicVideo: Video.Details.MusicVideo)
    case album(album: MediaItem)
    
    var empty: String {
        switch self {
        case .start:
            return "Loading your library"
        case .library:
            return "Your library is empty"
        case .recentlyAdded:
            return "You have no recently added songs"
        case .mostPlayed:
            return "You have no most played songs"
        case .recentlyPlayed:
            return "You have no recently played songs"
        case .favorites:
            return "You have no favorite songs"
        case .playingQueue:
            return "There is nothing in your queue at the moment"
        case .playlist:
            return "The playlist is empty"
        case .musicVideos:
            return "You have no music videos"
        case .search:
            return "Search did not find any results"
        case .musicMatch:
            return "Music Match is not available"
        case .movies:
            return "You have no movies"
        case .tvshows:
            return "You have no TV shows"
        case .movieSet:
            return "The movie set is empty"
        case .seasons:
            return "There are no seasons for this TV show"

        case .artist:
            return "This artist is not in your library"
        case .album:
            return "There are no albums for this artist"
        default:
            return "Navigation error"
        }
    }
    
    var label: Item {
        switch self {
        case .start:
            return Item(title: "Start",
                        description: "Loading your library",
                        icon: "music.quarternote.3"
            )
        case .library:
            return Item(title: "All Music",
                        description: "All the music in your library",
                        icon: "music.quarternote.3"
            )
        case .recentlyAdded:
            return Item(title: "Recently Added",
                        description: "Your recently added songs",
                        icon: "star"
            )
        case .mostPlayed:
            return Item(title: "Most Played",
                        description: "Your most played songs",
                        icon: "infinity"
            )
        case .recentlyPlayed:
            return Item(title: "Recently Played",
                        description: "Your recently played songs",
                        icon: "gobackward"
            )
        case .favorites:
            return Item(title: "Favorites",
                        description: "Your favorite songs",
                        icon: "heart"
            )
        case .playingQueue:
            return Item(title: "Now Playing",
                        description: "The current playlist",
                        icon: "list.triangle"
            )
        case .playlist(let file):
            return Item(title: file.title,
                        description: "Your playlist",
                        icon: "music.note.list"
            )
        case .musicVideos:
            return Item(title: "Music Videos",
                        description: "All the music videos in your library",
                        icon: "music.note.tv"
            )
        case .search:
            return Item(title: "Search",
                        description: "Search Results",
                        icon: "magnifyingglass"
            )
        case .musicMatch:
            return Item(title: "Music Match",
                        description: "Match playcounts and ratings between Kodi and Music",
                        icon: "arrow.triangle.2.circlepath"
            )
        case .movies:
            return Item(title: "Movies",
                        description: "Your movies",
                        icon: "film"
            )
        case .tvshows:
            return Item(title: "TV shows",
                        description: "Your TV shows",
                        icon: "tv"
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
