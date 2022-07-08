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
    /// The body of this View
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies, id: \.id) { movie in
                        /// - Note: `NavigationLink` is in a `Group` because it cannot have a 'dynamic' destination
                        Group {
                            if movie.media == .movie {
                                MovieItem(movie: movie)
                            } else {
                                MovieSetItem(movieSet: movie)
                            }
                        }
                        .buttonStyle(.card)
                        /// - Note: Context Menu must go after the Button Style or else it does not work...
                        .contextMenu(for: movie)
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .task(id: kodi.library.movies) {
            /// Remove all movies that are a part of a set and add the sets instead
            movies = (kodi.library.movieSets + kodi.library.movies.filter({$0.setID == 0})).sorted {
                $0.sortByTitle < $1.sortByTitle
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
                MediaArt.Poster(item: movie)
                    .frame(width: 300, height: 450)
                    .watchStatus(of: movie)
            })
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: movie)
            }
            
//            NavigationLink(destination: DetailsView(item: movie)) {
//                MediaArt.Poster(item: movie)
//                    .frame(width: 300, height: 450)
//                    .watchStatus(of: movie)
//            }
        }
    }
    
    struct MovieSetItem: View {
        let movieSet: any KodiItem
        var body: some View {
            NavigationLink(destination: MovieSetView(set: movieSet as! Video.Details.MovieSet)) {
                MediaArt.Poster(item: movieSet)
                    .frame(width: 300, height: 450)
                    .watchStatus(of: movieSet)
            }
        }
    }
}
