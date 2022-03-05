//
//  MoviesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI


/// A View for Movie items
struct MoviesView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies we want to show
    @State var movies: [KodiItem] = []
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(movies) { movie in
                ItemsView.Item(item: movie.binding())
            }
        }
        .task {
            print("MoviesView task!")
            /// Filter the movies
            movies = kodi.library.filter(KodiFilter(media: .movie))
            /// Set fanart
            //router.fanart = ""
        }
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
                RouterLink(item: .details(item: movie)) {
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
        
        /// The Router model
        @EnvironmentObject var router: Router
        
        /// The Set item for this View
        let set: KodiItem.MovieSetItem
        /// The movies we want to show
        @State var movies: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List() {
#if os(tvOS)
                PartsView.TitleHeader()
#endif
                if !set.description.isEmpty {
                    ItemsView.Description(description: set.description)
                }
                ForEach(movies) { movie in
                    RouterLink(item: .details(item: movie)) {
                        ItemsView.Basic(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.KodiItem(item: movie))
                }
            }
            .task {
                print("MoviesView.Set task!")
                /// Get set movies
                movies = kodi.library.filter(KodiFilter(media: .movie, setID: set.setID))
                /// Set fanart
                //router.fanart = set.fanart
//                if let item = kodi.library.first(where: { $0.setID == set.setID}) {
//                    //appState.filter.title = item.setInfo.title
//                    //setDescription = item.setInfo.description
//                    //appState.filter.fanart = item.setInfo.fanart
//                    //appState.filter.subtitle = "Movies"
//                    //appState.filter.media = .movie
//                    //appState.filter.setID = set.setID
//                    movies = kodi.library.filter(appState.filter)
//                }
            }
            //.iOS { $0.navigationTitle(appState.filter.title ?? "") }
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
            
            RouterLink(item: .moviesSet(set: movie.setInfo)) {
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
