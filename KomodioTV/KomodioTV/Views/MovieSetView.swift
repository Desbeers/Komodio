//
//  MovieSetView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for a set of Movie items
struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The Set item to show in this View
    let set: MediaItem
    /// The focused item
    @FocusState private var selectedItem: MediaItem?
    /// The movies to show in this View
    private var movies: [MediaItem] {
        kodi.media.filter(MediaFilter(media: .movie, movieSetID: set.movieSetID))
    }
    /// The body of this View
    var body: some View {
        VStack {
            /// Header
            PartsView.Header2(item: set)
            if !set.description.isEmpty {
                Text(set.description)
            }
            if !movies.isEmpty {
              TabView {
                ForEach(movies) { movie in
                    MovieItem(movie: movie)
                }
              }
              .tabViewStyle(.page)
              .padding(.bottom)
            }
        }
        .background(ArtView.SelectionBackground(item: set))
        .animation(.default, value: selectedItem)
    }
}

extension MovieSetView {
    
    /// A View for one Movie item in a Movie Set
    struct MovieItem: View {
        /// The Movie item to show in this View
        let movie: MediaItem
        /// The body of this View
        var body: some View {
            NavigationLink(destination: DetailsView(item: movie)) {
                HStack(alignment: .top) {
                    ArtView.Poster(item: movie)
                        .cornerRadius(6)
                        .watchStatus(of: movie)
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.title2)
                        Text(movie.details)
                            .font(.caption2)
                            .padding(.bottom)
                        Text(movie.description)
                    }
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 300)
            }
            .buttonStyle(.card)
            /// - Note: Context Menu must go after the Button Style or else it does not work...
            .contextMenu(for: movie)
        }
    }
}
