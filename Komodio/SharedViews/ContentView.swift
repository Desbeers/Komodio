//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter

// MARK: - Routes
struct ContentView: View {
    var body: some View {
        SwitchRoutes {
            Route("Home/", content: HomeView())
            Route("Movies/", content: MoviesView())
            Route("Movies/Details/*", content: DetailsView())
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
    }
}
