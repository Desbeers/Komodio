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
        }
    }
}

extension MoviesView {
    
    /// A View for a movie item
    struct Item: View {
        /// The Movie item from the library
        @Binding var movie: KodiItem
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
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Set item for this View
        let set: KodiItem.MovieSetItem
        /// The movies we want to show
        @State var movies: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List() {
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
            }
        }
    }
    
    /// A View for a movie set item
    struct SetItem: View {
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
