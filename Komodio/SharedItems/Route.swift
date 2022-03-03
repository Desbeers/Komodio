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
    case moviesSet(setID: Int)
    case tvshows
    case episodes(tvshow: KodiItem)
    case musicVideos
    case musicVideosItems(artist: KodiItem)
    case genres
    case genresItems(genre: GenreItem)
    case details(item: KodiItem)
    case player
    /// The items to show in the NavbarView
    static let menuItems: [Route] = [.home, .movies, tvshows, musicVideos, genres]
}

extension Route {
    
    /// The title of the route item
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .movies:
            return "Movies"
        case .moviesSet(let setID):
            return "Movie Set \(setID)"
        case .tvshows:
            return "TV shows"
        case .episodes:
            return "Episodes"
        case .musicVideos:
            return "Music Videos"
        case .musicVideosItems:
            return "Music Videos Items"
        case .genres:
            return "Genres"
        case .genresItems:
            return "Genres Items"
        case .details(let kodiID):
            return kodiID.title
        case .player:
            return "Player"
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
        case .details(let kodiID):
            return kodiID.title
        default:
            return "questionmark"
        }
    }
}

extension Route {
    
    @ViewBuilder var destination: some View {
    //@ViewBuilder func destination() -> some View {
        switch self {
        case .home:
            HomeView()
        case .movies:
            MoviesView(filter: KodiFilter(media: .movie))
        case .moviesSet(let setID):
            MoviesView.Set(setID: setID)
        
        case .tvshows:
            TVshowsView(filter: KodiFilter(media: .tvshow))
        case .episodes(let tvshow):
            EpisodesView(tvshow: tvshow)
        
        case .musicVideos:
            MusicVideosView(filter: KodiFilter(media: .musicvideo))
        case .musicVideosItems(let artist):
            MusicVideosView.Items(artist: artist)
        
        
        case .genres:
            GenresView()
        case .genresItems(let genre):
            GenresView.Items(genre: genre)
        case .details(let item):
            DetailsView(item: item.binding())
        default:
            Text("TODO")
        }
    }
}
