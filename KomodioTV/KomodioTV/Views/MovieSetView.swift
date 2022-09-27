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
    //@EnvironmentObject var appState: AppState
    /// The movie set to show in this View
    let set: Video.Details.MovieSet
    /// The movies to show
    @State private var movies: [Video.Details.Movie] = []
    
    @FocusState var selectedMovie: Video.Details.Movie?
    /// The body of this View
    var body: some View {
        VStack {
            Text(set.title)
                .font(.title)
            Text(set.plot)
                .font(.caption)
            if !movies.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(movies) { movie in
                            MoviesView.MovieItem(movie: movie)
                                .padding(EdgeInsets(top: 40, leading: 0, bottom: 80, trailing: 0))
                                .focused($selectedMovie, equals: movie)
                        }
                    }
                    
                    .padding(.horizontal, 80)
                }
                if let selection = selectedMovie {
                    VStack(alignment: .leading) {
                        Text("\(selection.title) | \(selection.year.description)")
                            .font(.title2)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text("\(selection.plot)")
                            .lineLimit(2)
                            //.padding(.bottom, 40)
                            //.padding(.horizontal, 80)
                    }
                    .frame(minWidth: 1600, maxWidth: 1600, alignment: .leading)
                }
            }
            Spacer()
//            /// TabView will crash when movies is still empty
//            if !movies.isEmpty {
//                TabView {
//                    ForEach(movies) { movie in
//                        HStack {
//                            MoviesView.MovieItem(movie: movie)
//                                .buttonStyle(.card)
//                            VStack {
//                                Text(movie.title)
//                                    .font(.title2)
//                                Text(movie.year.description)
//                                    .font(.subheadline)
//                                Text(movie.plot)
//                            }
//                        }
//                    }
//                }
//                .tabViewStyle(.page)
//            }
        }
        .animation(.default, value: selectedMovie)
        .buttonStyle(.card)
        .task(id: kodi.library.movies) {
            movies = kodi.library.movies.filter( {$0.setID == set.setID } ).sorted {$0.year < $1.year}
        }
    }
}
