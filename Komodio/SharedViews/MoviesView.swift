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
    /// The View
    var body: some View {
        ItemsView.List() {
            VStack {
                ForEach(movies) { movie in
                    ItemsView.Item(item: movie.binding())
                }
            }
            /// Move the first row below the tabs on tvOS
            .tvOS { $0.padding(.top, 160) }
        }
        .task {
            print("MoviesView task!")
            appState.filter = filter
            appState.filter.title = "Movies"
            appState.filter.subtitle = nil
            appState.filter.fanart = nil
            /// Filter the movies
            movies = kodi.library.filter(filter)
        }
        /// Set the navigation title for iOS
        .iOS { $0.navigationTitle("Movies") }
    }
}

extension MoviesView {
    
    /// A View for a movie item
    struct Item: View {
        /// The Movie item from the library
        @Binding var movie: KodiItem
        /// The current library  filter
        let filter: KodiFilter
        /// The View
        var body: some View {
            
            if movie.setID == 0 {
                StackNavLink(path: "/Movies/Details/\(movie.id)",
                             filter: filter,
                             destination: DetailsView(item: movie.binding())
                ) {
                    ItemsView.Basic(item: movie.binding())
                }
                .buttonStyle(ButtonStyles.KodiItem(item: movie))
            } else {
                /// View this movie as a movie set
                SetItem(movie: movie)
            }
        }
    }
    
    struct Set: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Set ID for this View
        let setID: Int
        /// The movies we want to show
        @State var movies: [KodiItem] = []
        /// The set info
        @State var setDescription = ""
        /// The View
        var body: some View {
            ItemsView.List() {
#if os(tvOS)
                PartsView.TitleHeader()
#endif
                if !setDescription.isEmpty {
                    ItemsView.Description(description: setDescription)
                }
                ForEach(movies) { movie in
                    StackNavLink(path: "/Movies/Details/\(movie.id)",
                                 filter: appState.filter,
                                 destination: DetailsView(item: movie.binding())
                    ) {
                        ItemsView.Basic(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.KodiItem(item: movie))
                }
            }
            .task {
                print("MoviesView.Set task!")
                /// Get set info
                if let item = kodi.library.first(where: { $0.setID == setID}) {
                    appState.filter.title = item.setInfo.title
                    setDescription = item.setInfo.description
                    appState.filter.fanart = item.setInfo.fanart
                    appState.filter.subtitle = "Movies"
                    appState.filter.media = .movie
                    appState.filter.setID = setID
                    movies = kodi.library.filter(appState.filter)
                }
            }
            .iOS { $0.navigationTitle(appState.filter.title ?? "") }
        }
    }
    
    /// A View for a movie set item
    struct SetItem: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The Movie item from the library
        let movie: KodiItem
        /// The View
        var body: some View {
            StackNavLink(path: "/Movies/Set/\(movie.setID)",
                         filter: appState.filter,
                         destination: Set(setID: movie.setID)
            ) {
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
            .buttonStyle(ButtonStyles.KodiItem(item: movie))
        }
    }
    
    
}
