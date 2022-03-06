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
    case genres
    case genresItems(genre: MediaItem)
    case details(item: MediaItem)
    case player
    case table
    /// The items to show in the NavbarView
    static let menuItems: [Route] = [.home, .movies, tvshows, musicVideos, genres, table]
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
        case .genres:
            return "Genres"
        case .genresItems(let genre):
            return genre.title
        case .details(let item):
            return item.title
        case .player:
            return "Player"
        case .table:
            return "Debug Table"
        }
    }
}

extension Route {
    
    /// The symbol for the route item
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
        case .genresItems:
            return "Genres Items"
        case .details(let item):
            return item.title
        case .table:
            return "testtube.2"
        default:
            return "questionmark"
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
        case .details(let item):
            fanart = item.fanart.isEmpty ? item.poster : item.fanart
        default:
            break
        }
        return fanart
    }
}

extension Route {
    
    @ViewBuilder var destination: some View {
    //@ViewBuilder func destination() -> some View {
        switch self {
        case .home:
            HomeView()
        case .movies:
            MoviesView()
        case .moviesSet(let set):
            MoviesView.Set(set: set)
        
        case .tvshows:
            TVshowsView(filter: KodiFilter(media: .tvshow))
        case .episodes(let tvshow):
            EpisodesView(tvshow: tvshow)
        
        case .musicVideos:
            MusicVideosView()
        case .musicVideosItems(let artist):
            MusicVideosView.Items(artist: artist)
        
        
        case .genres:
            GenresView()
        case .genresItems(let genre):
            GenresView.Items(genre: genre)
        case .details(let item):
            DetailsView(item: item.binding())
#if os(macOS)
        case .table:
            TableView()
#endif
        default:
            Text("Not implemented")
        }
    }
}
