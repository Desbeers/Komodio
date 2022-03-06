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
    /// The View
    var body: some View {
        ItemsView.List() {
            ForEach(kodi.media.filter(KodiFilter(media: .movie))) { movie in
                ItemsView.Item(item: movie.binding())
            }
        }
        .task {
            print("MoviesView task!")
        }
    }
}

extension MoviesView {
    
    /// A View for a movie item
    struct Item: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Movie item from the library
        @Binding var movie: MediaItem
        /// The View
        var body: some View {
            if movie.movieSetID == 0 {
                RouterLink(item: .details(item: movie)) {
                    ItemsView.Basic(item: movie.binding())
                }
                .buttonStyle(ButtonStyles.MediaItem(item: movie))
            } else {
                /// View this movie as a movie set
                if let set = kodi.media.first(where: { $0.media == .movieSet && $0.movieSetID == movie.movieSetID } ) {
                    SetItem(movieSet: set)
                }
            }
        }
    }
    
    struct Set: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Set item for this View
        let set: MediaItem
        /// The View
        var body: some View {
            ItemsView.List() {
                if !set.description.isEmpty {
                    ItemsView.Description(description: set.description)
                }
                ForEach(kodi.media.filter(KodiFilter(media: .movie, setID: set.movieSetID))) { movie in
                    RouterLink(item: .details(item: movie)) {
                        ItemsView.Basic(item: movie.binding())
                    }
                    .buttonStyle(ButtonStyles.MediaItem(item: movie))
                }
            }
            .task {
                print("MoviesView.Set task!")
            }
        }
    }
    
    /// A View for a movie set item
    struct SetItem: View {
        /// The Movie Set item from the library
        let movieSet: MediaItem
        /// The View
        var body: some View {
            RouterLink(item: .moviesSet(set: movieSet)) {
                ItemsView.Basic(item: movieSet.binding())
            }
            .buttonStyle(ButtonStyles.MediaItem(item: movieSet))
        }
    }
}
