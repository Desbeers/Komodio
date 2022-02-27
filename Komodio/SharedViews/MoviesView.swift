//
//  MoviesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI


/// A View for Movie items
struct MoviesView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The library filter
    /// - Note: A `State` because this View can calitself again when viewing a set and that has a different filter
    @State var filter: KodiFilter
    /// The movies we want to show
    @State var movies: [KodiItem] = []
    /// Optional Set ID
    var setID: Int?
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(movies) { movie in
                MovieItem(filter: filter, movie: movie.binding())
            }
        }
        .task {
            print("MoviesView task!")
            appState.filter = filter
            appState.filter.title = "Movies"
            appState.filter.subtitle = nil
            /// Filter the movies
            movies = kodi.library.filter(filter)
        }
        .navigationTitle("Movies")
    }
}

extension MoviesView {
    
    /// A View for a movie item
    struct MovieItem: View {
        /// The current library  filter
        let filter: KodiFilter
        /// The Movie item from the library
        @Binding var movie: KodiItem
        /// The View
        var body: some View {
            if movie.setID == 0 || filter.setID != nil || filter.search != nil {
                StackNavLink(path: "/Movies/Details/\(movie.id)",
                             filter: filter,
                             destination: DetailsView(item: movie.binding())
                ) {
                    ItemsView.Item(item: movie.binding())
                }
                .buttonStyle(ButtonStyles.KodiItem(item: movie))
            } else {
                /// It is a movie set
                StackNavLink(path: "/Movies/Set/\(movie.setID)",
                             filter: filter,
                             destination: MovieSetView(setID: movie.setID)
                             //destination: MoviesView(filter: filter, setID: movie.setID)
                ) {
                    MovieSetItem(movie: movie)
                }
                .buttonStyle(ButtonStyles.KodiItem(item: movie))
            }
        }
    }
    
    /// A View for a movie set item
    struct MovieSetItem: View {
        /// The Movie item from the library
        let movie: KodiItem
        /// The View
        var body: some View {
            HStack(spacing: 0) {
                ArtView.PosterList(poster: movie.setInfo.art.isEmpty ? movie.poster : movie.setInfo.poster)
                VStack(alignment: .leading) {
                    HStack {
                        Text(movie.setName)
                            .font(.headline)
                        Spacer()
                        Text(movie.setInfo.genres)
                            .font(.caption)
                    }
                    Text("\(movie.setInfo.count) movies")
                        .font(.caption.italic())
                    Divider()
                    Text(movie.setInfo.description.isEmpty ? "Movie Set" : movie.setInfo.description)
                        .lineLimit(2)
                    Divider()
                    Text(movie.setInfo.movies)
                        .font(.caption)
                        .lineLimit(1)
                }
                .padding(.horizontal)
            }
        }
    }
    
    
    struct MovieSetView: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Set ID for this View
        let setID: Int
        /// The movies we want to show
        @State var movies: [KodiItem] = []
        /// The View
        var body: some View {
            
            ItemsView.List() {
                ForEach(movies) { movie in
                    StackNavLink(path: "/Movies/Details/\(movie.id)",
                                 filter: appState.filter,
                                 destination: DetailsView(item: movie.binding())
                    ) {
                        ItemsView.Item(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.KodiItem(item: movie))
                }
            }
            .task {
                /// Get set info
                if let setInfo = kodi.library.first(where: { $0.setID == setID}) {
                    appState.filter.title = setInfo.setInfo.title
                    appState.filter.subtitle = "Movies"
                    appState.filter.setID = setID
                    movies = kodi.library.filter(appState.filter)
                }
            }
            .navigationTitle(appState.filter.title ?? "")
        }
    }
    
    
}
