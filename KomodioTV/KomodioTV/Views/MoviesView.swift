//
//  MoviesView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Movies' SwiftUI View
/// - Note: Movies that are part of a Movie Set will be grouped together and linked to ``MovieSetView`` when sorted by 'title.
struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show; loaded by a 'Task'.
    @State private var movies: [Video.Details.Movie] = []
    /// The movie sets to show; loaded by a 'Task'.
    @State private var movieSets: [Video.Details.MovieSet] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// Sort items toggle
    @AppStorage("sortOrder") private var sortOrder: Parts.Sort = .title
    /// The loading state of the view
    @State private var state: Parts.State = .loading
    /// The body of this View
    var body: some View {
        VStack {
            VStack {
                switch state {
                case .loading:
                    Text("Loading your movies")
                case .empty:
                    Text("There are no movies in your library")
                case .ready:
                    content
                case .offline:
                    state.offlineMessage
                }
            }
        }
        .animation(.default, value: hideWatched)
        .animation(.default, value: sortOrder)
        .task(id: kodi.library.movies) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                movies = kodi.library.movies
                movieSets = kodi.library.movieSets
                state = .ready
            }
        }
    }
    /// The content of this View
    var content: some View {
        ScrollView {
            HStack {
                Button(action: {
                    hideWatched.toggle()
                }, label: {
                    Text(hideWatched ? "Show all movies" : "Hide watched movies")
                        .frame(width: 400)
                        .padding()
                })
                Picker(selection: $sortOrder, label: Text("Sort order").padding(.leading)) {
                    ForEach(Array(Parts.Sort.allCases), id: \.self) {
                        Text($0.rawValue)
                            .padding(.vertical)
                            .padding(.trailing)
                            .frame(width: 240, alignment: .leading)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            .buttonStyle(.card)
            .padding()
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(filterMovies(movies, sortOrder: sortOrder, hideWatched: hideWatched), id: \.id) { movie in
                    Group {
                        if movie.media == .movie {
                            MovieItem(movie: movie)
                                .overlay(alignment: .bottom) {
                                    if sortOrder != .title {
                                        Text(Parts.secondsToTime(seconds: movie.runtime))
                                            .frame(maxWidth: .infinity)
                                            .background(.thinMaterial)
                                            .cornerRadius(10)
                                            .padding(2)
                                    }
                                }
                                .padding(.bottom, 40)
                        } else {
                            MovieSetItem(movieSet: movie)
                                .padding(.bottom, 40)
                        }
                    }
                    .buttonStyle(.card)
                    /// - Note: Context Menu must go after the Button Style or else it does not work...
                    .contextMenu(for: movie)
                }
            }
        }
    }
    
    /// Filyter and sort the list of movies
    /// - Parameters:
    ///   - movies: All the movies
    ///   - sortOrder: The sort order
    ///   - hideWatched: Book to hide watched movies
    /// - Returns: A filtered list of movies, optional with 'sets'
    private func filterMovies(_ movies: [Video.Details.Movie], sortOrder: Parts.Sort, hideWatched: Bool) -> [any KodiItem] {
        var movieList: [any KodiItem] = []
        switch sortOrder {
        case .title:
            /// Remove all movies that are a part of a set and add the sets instead
            movieList = (movies.filter({$0.setID == 0}) + self.movieSets).sorted(by: {$0.sortByTitle < $1.sortByTitle})
        case .runtime:
            movieList = movies.sorted(by: {$0.runtime < $1.runtime})
        }
        if hideWatched {
            movieList = movieList.filter {$0.playcount < 1}
        }
        return movieList
    }
}

extension MoviesView {
    
    struct MovieItem: View {
        let movie: any KodiItem
        @State private var isPresented = false
        var body: some View {
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                KodiArt.Poster(item: movie)
                    .scaledToFill()
                    .frame(width: 300, height: 450)
                    .watchStatus(of: movie)
            })
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: movie)
            }
        }
    }
    
    struct MovieSetItem: View {
        let movieSet: any KodiItem
        var body: some View {
            NavigationLink(destination: MovieSetView(set: movieSet as! Video.Details.MovieSet)) {
                KodiArt.Poster(item: movieSet)
                    .scaledToFill()
                    .frame(width: 300, height: 450)
                    .watchStatus(of: movieSet)
            }
        }
    }
}
