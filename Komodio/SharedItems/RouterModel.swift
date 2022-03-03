//
//  RouterModel.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
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
    
    static let menuItems: [Route] = [.home, .movies, tvshows, musicVideos, genres]
    
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

struct RouteItem {
    let id = UUID()
    let name: String
    let symbol: String
}

class Router: ObservableObject {
    
    @Published var routes: [Route] = [.home]
    
    var selection: Route = .home
    
    @Published var navbar: Route? = .home {
        didSet {
            /// Don't bother with nil's or repeated selection
            if let selection = navbar, selection != oldValue, selection != currentRoute {
                routes = [selection]
            }
        }
    }
    
    var currentRoute: Route {
        routes.last ?? .home
    }
    
    @MainActor func push(_ route: Route) {
        debugPrint("Push \(route.title)")
        routes.append(route)
    }
    
    @discardableResult
    @MainActor func pop() -> Route? {
        routes.popLast()
    }
}

struct RouterLink<Label: View>: View {
    
    @EnvironmentObject var router: Router
    
    private var item: Route
    private var label: Label
    /// Init the RouterLink
    init(item: Route, @ViewBuilder label: () -> Label) {
        self.item = item
        self.label = label()
    }
    /// The View
    var body: some View {
#if os(macOS)
        Button(action: {
            router.push(item)
        }, label: {
            label
        })
#else
        NavigationLink(destination: item.destination.navigationTitle(item.rawValue)) {
            label
        }
#endif
    }
}
