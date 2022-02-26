//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

// MARK: - Routes
struct ContentView: View {
    
    /// The AppState model
    @EnvironmentObject var appState: AppState
    
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    var body: some View {
        ZStack(alignment: .top) {
            SwitchRoutes {
                Route("Home/", content: HomeView())
                Route("Movies/", content: MoviesView(
                    filter: KodiFilter(media: .movie,
                                       title: "Movies",
                                       subtitle: nil)
                ))
                //Route("Movies/Details/:itemID", content: DetailsView())
                
                Route("Movies/Details/:itemID", validator: validateItemID) { itemID in
                    DetailsView(item: itemID.binding())
                }
                
                Route("/player", content: PlayerView())
                Route("Movies/Set/:setID") { info in
                    MoviesView.Set(setID: Int(info.parameters["setID"]!)!)
                }
                Route("TV shows/*", content: TVshowsView(
                    filter: KodiFilter(media: .tvshow,
                                       title: "TV shows",
                                       subtitle: nil)
                ))
                Route("Music Videos/", content: MusicVideosView(
                    filter: KodiFilter(media: .musicvideo,
                                       title: "Music Videos",
                                       subtitle: nil)
                ))
                Route("Music Videos/Artist/:itemID", validator: validateItemID) { kodiItem in
                    MusicVideosView.Items(artist: kodiItem)
                }
                Route("Genres/*", content: GenresView())
                Route {
                    Navigate(to: "/Home")
                }
            }
            .navigationTransition()
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        
    }
    
    func validateItemID(routeInfo: RouteInformation) -> KodiItem {
        
        let id = routeInfo.parameters["itemID"] ?? ""
        let item = kodi.library.first(where: { $0.id == id })!
        debugPrint("Validating \(item.title)")
//        Task { @MainActor in
//            appState.filter.title = item.title
//            appState.filter.subtitle = item.subtitle.isEmpty ? nil : item.subtitle
//        }
        return item
    }
    
}
