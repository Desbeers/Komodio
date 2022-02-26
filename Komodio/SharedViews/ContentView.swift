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
            Route("Movies/", content: MoviesView(filter: KodiFilter(media: .movie)))
            //Route("Movies/Details/:itemID", content: DetailsView())
            
            Route("Movies/Details/:itemID", validator: validateItemID) { itemID in
                DetailsView(item: itemID)
            }
            
            Route("Player/", content: PlayerView())
            Route("Movies/Set/:setID") { info in
                MoviesView.Set(setID: Int(info.parameters["setID"]!)!)
            }
            Route("TV shows/*", content: TVshowsView())
            Route("Music Videos/*", content: MusicVideosView())
            Route("Genres/*", content: GenresView())
            Route {
                Navigate(to: "/Home")
            }
        }
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        .animation(.default, value: appState.filter)
        .navigationTitle(appState.filter.title ?? "Komodio")
        //.navigationSubtitle(appState.filter.subtitle ?? "")
    }
    
    func validateItemID(routeInfo: RouteInformation) -> KodiItem {
        
        let id = UUID(uuidString: routeInfo.parameters["itemID"] ?? "")
        let item = kodi.library.first(where: { $0.id == id })!
        Task { @MainActor in
            appState.filter.title = item.title
        }
        return item
    }
    
}
