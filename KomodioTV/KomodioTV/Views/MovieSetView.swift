//
//  MovieSetView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieSetView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The Set item for this View
    let set: MediaItem
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// The View
    var body: some View {
        VStack {
            /// Header
            PartsView.Header2(item: set)
            if !set.description.isEmpty {
                Text(set.description)
            }
            
            if !movies.isEmpty {
              TabView {
                ForEach($movies) { movie in
                    Movie(movie: movie)
                    //.focusable()
                }
              }
              .tabViewStyle(.page)
              .padding(.bottom)
              //.frame(maxHeight: 400)
            }
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHStack(spacing: 0) {
//                    ForEach($movies) { $movie in
//                        NavigationLink(destination: DetailsView(item: $movie)) {
//                            ArtView.Poster(item: movie)
//                        }
//                        .buttonStyle(.card)
//                        .padding()
//                        .focused($selectedItem, equals: movie)
//                        .zIndex(movie == selectedItem ? 2 : 1)
//                    }
//                }
//            }
//            VStack {
//            if let selected = selectedItem {
//                Text(selected.details)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            }
//            .frame(height: 200)
        }
        .background(ArtView.SelectionBackground(item: set))
        .animation(.default, value: selectedItem)
        .task {
            movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie, movieSetID: set.movieSetID))
        }
    }
}

extension MovieSetView {
    struct Movie: View {
        @Binding var movie: MediaItem
        var body: some View {
            NavigationLink(destination: DetailsView(item: $movie)) {
                HStack(alignment: .top) {
                    ArtView.Poster(item: movie)
                        .cornerRadius(6)
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
        }
    }
}
