//
//  File.swift
//  Komodio
//
//  Created by Nick Berendsen on 03/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

enum Route: Equatable, Hashable {
    case home
    case movies
    case moviesSet(set: MediaItem)
    case tvshows
    case episodes(tvshow: MediaItem)
    case musicVideos
    case musicVideosItems(artist: MediaItem)
    case musicVideosAlbum(album: MediaItem)
    case genres
    case genresItems(genre: MediaItem)
    case details(item: MediaItem)
    case player(items: [MediaItem])
    case artists
    case albums(artist: MediaItem)
    case songs(album: MediaItem)
    case table
    /// The items to show as main menu items
    /// - Note: iOS has no 'home' button because the buttons are only shown on the homepage
    #if !os(macOS)
    static let menuItems: [Route] = [.movies, tvshows, musicVideos, artists, genres]
    #else
    static let menuItems: [Route] = [.home, .movies, tvshows, musicVideos, artists, genres]
    #endif
}

extension Route {
    
    /// The title of the route item
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .movies:
            return "Movies"
        case .moviesSet(let set):
            return set.title
        case .tvshows:
            return "TV shows"
        case .episodes(let tvshow):
            return tvshow.title
        case .musicVideos:
            return "Music Videos"
        case .musicVideosItems(let artist):
            return artist.title
        case .musicVideosAlbum(let album):
            return album.album
        case .genres:
            return "Genres"
        case .genresItems(let genre):
            return genre.title
        case .details(let item):
            return item.title
        case .player:
            return "Now playing..."
        case .table:
            return "Debug Table"
        case .artists:
            return "Artists"
        case .albums(let artist):
            return artist.title
        case .songs(let album):
            return album.title
        }
    }
}

extension Route {
    
    /// The SF symbol for the route item
    /// - Note: Only main menu items need to have a symbol
    var symbol: String {
        switch self {
        case .home:
            return "house"
        case .movies:
            return "film"
        case .tvshows:
            return "tv"
        case .musicVideos:
            return "music.quarternote.3"
        case .genres:
            return "list.star"
        case .artists:
            return "person.2"
        case .table:
            return "testtube.2"
        default:
            return "questionmark"
        }
    }
}

extension Route {
    var isPlayer: Bool {
        switch self {
        case .player:
            return true
        default:
            return false
        }
    }
}

extension Route {
    
    // MARK: Fanart
    
    /// The fanart for the route item
    var fanart: String {
        var fanart = ""
        switch self {
            
        case .moviesSet(let set):
            fanart = set.fanart
        case .episodes(let tvshow):
            fanart = tvshow.fanart
        case .musicVideosItems(let artist):
            fanart = artist.fanart
        case .musicVideosAlbum(let album):
            fanart = album.fanart
        case .albums(let artist):
            fanart = artist.fanart
        case .songs(let album):
            fanart = album.fanart
        default:
            break
        }
        return fanart
    }
}

extension Route {
    
    @ViewBuilder var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .movies:
            MoviesView()
        case .moviesSet(let set):
            MoviesView.Set(set: set)
        
        case .tvshows:
            TVshowsView()
        case .episodes(let tvshow):
            EpisodesView(tvshow: tvshow)
        
            /// # Music Videos
            
        case .musicVideos:
            MusicVideosView()
        case .musicVideosItems(let artist):
            MusicVideosView.Items(artist: artist)
        case .musicVideosAlbum(let album):
            MusicVideosView.Album(album: album)
        
        case .genres:
            GenresView()
        case .genresItems(let genre):
            GenresView.Items(genre: genre)
        case .details(let item):
            DetailsView(item: item)
            
            /// # Audio
            
        case .artists:
            ArtistsView()
        case .albums(let artist):
            AlbumsView(artist: artist)
        case .songs(let album):
            SongsView(album: album)
            
            /// # Player
        case .player(let items):
            PlayerView(items: items)
            
#if os(macOS)
        case .table:
            TableView()
#endif
        default:
            Text("Not implemented")
        }
    }
}
