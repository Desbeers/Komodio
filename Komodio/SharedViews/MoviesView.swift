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
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(movies) { movie in
                    
                    StackLink(path: "/Movies/Details/\(movie.id.uuidString)", filter: $filter, destination: DetailsView(item: movie)) {
                        Text(movie.title)
                    }
                    
//                    NavLink(to: "/Movies/Details/\(movie.id.uuidString)") {
//                        Text(movie.title)
//                    }
                    //MovieItem(filter: filter, movie: movie.binding())
                }
            }
        }
        //.buttonStyle(.plain)
        .task {
            print("MoviesView task!")
            navigator.clear()
            appState.filter.media = .movie
            appState.filter.title = "Movies"
            movies = kodi.library.filter(filter)
            dump(navigator)
        }
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
