//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A SwiftUI View for Movie items
/// - Note: Movies that are part of a Movie Set will be grouped together and linked to ``MovieSetView``.
struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show; loaded by a 'Task'.
    @State private var movies: [any KodiItem] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    //@FocusState private var selectedItem: MediaItem?
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The loading state of the view
    @State private var state: AppState.State = .loading
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
        .task(id: kodi.library.movies) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                /// Remove all movies that are a part of a set and add the sets instead
                movies = (kodi.library.movieSets + kodi.library.movies.filter({$0.setID == 0}))
                    .sorted { $0.sortByTitle < $1.sortByTitle }
                state = .ready
            }
        }
    }
    /// The content of this View
    var content: some View {
        ScrollView {
            Button(action: {
                hideWatched.toggle()
            }, label: {
                Text(hideWatched ? "Show all movies" : "Hide watched movies")
                    .frame(width: 400)
                    .padding()
            })
            .buttonStyle(.card)
            .padding()
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(movies.filter { $0.playcount < (hideWatched ? 1 : 1000) }, id: \.title) { movie in
                    Group {
                        if movie.media == .movie {
                            MovieItem(movie: movie)
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
