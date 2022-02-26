//
//  MoviesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct MoviesView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The route navigation
    @EnvironmentObject var routeInformation: RouteInformation
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The library filter
    @State var filter: KodiFilter
    /// The movies we want to show
    @State var movies: [KodiItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(movies) { movie in
                
                /// Build a new filter for the DetailsView
                let newFilter = KodiFilter(
                    media: .movie,
                    item: movie,
                    title: movie.title,
                    subtitle: movie.subtitle
                )
                
                StackNavLink(path: "/Movies/Details/\(movie.id)",
                             filter: newFilter,
                             destination: DetailsView(item: movie.binding())
                ) {
                    ItemsView.Item(item: movie.binding())
                }
                .buttonStyle(ButtonStyles.KodiItem(item: movie))
            }
        }
        .task {
            print("MoviesView task!")
            movies = kodi.library.filter(filter)
            appState.filter.title = "Movies"
            appState.filter.subtitle = nil
            
        }
        .navigationTitle("Movies")
    }
}

extension MoviesView {
    
    struct Set: View {
        let setID: Int
        var body: some View {
            Text("Movie Set View!")
        }
    }
}
