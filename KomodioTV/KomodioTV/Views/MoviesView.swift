//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A SwiftUI View for Movie items
///
/// This View will show all movies from the Kodi database.
///
/// - A 'toggle' can hide the watched movies.
/// - The movies are sorted by title.
/// - Movies that are part of a Movie Set will be grouped together and linked to ``MovieSetView``.
struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The movies to show in this View
    private var movies: [MediaItem] {
        kodi.media.filter(MediaFilter(media: .movie)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
    }
    /// The movies to show; loaded by a 'Task'.
    //@State private var movies: [MediaItem] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState private var selectedItem: MediaItem?
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The body of this View
    var body: some View {
        HStack(alignment: .top) {
            // MARK: Sidebar
            VStack {
                Button(action: {
                    hideWatched.toggle()
                }, label: {
                    Text(hideWatched ? "Show all movies" : "Hide watched movies")
                        .padding()
                })
                .buttonStyle(.card)
                /// - Remark: Don't animate the button; it is ugly
                .transaction { transaction in
                    transaction.animation = nil
                }
                Text("\(movies.count)" + (hideWatched ? " unwatched" : "") + " movies")
                    .font(.caption)
                    .foregroundColor(.secondary)
                // MARK: Selected item info
                if let item = selectedItem {
                    VStack {
                        Text(item.title)
                            .font(.headline)
                        Text(item.details)
                            .font(.caption)
                        Divider()
                        Text(item.description)
                        /// - Note: If the item is a movie set item; list all movies that is part of this set
                        if item.movieSetID != 0 {
                            ForEach(KodiConnector.shared.media.filter { $0.media == .movie && $0.movieSetID == item.movieSetID}) { movie in
                                Label(movie.title, systemImage: "film")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .labelStyle(LabelStyles.MovieSet())
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
            .frame(width: 500)
            /// - Note: Make the section focussable so we can reach the 'watched' toggle-button
            .focusSection()
            // MARK: Movie Grid
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { movie in
                        /// - Note: `NavigationLink` is in a `Group` because it cannot have a 'dynamic' destination
                        Group {
                            if movie.movieSetID == 0 {
                                NavigationLink(destination: DetailsView(item: movie)) {
                                    ArtView.Poster(item: movie)
                                        .watchStatus(of: movie)
                                }
                            } else {
                                NavigationLink(destination: MovieSetView(set: movie)) {
                                    ArtView.Poster(item: movie)
                                        .watchStatus(of: movie)
                                }
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        /// - Note: Context Menu must go after the Button Style or else it does not work...
                        .contextMenu(for: movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
//                /// Don't animate the grid; posters will 'fly'...
//                .transaction { transaction in
//                    transaction.animation = nil
//                }
            }
        }
        .animation(.default, value: selectedItem)
        .animation(.default, value: movies)
//        .task {
//            movies = getMovies()
//        }
//        .onChange(of: hideWatched) { _ in
//            movies = getMovies()
//        }
        .setSelection(of: selectedItem)
    }
    
    /// Get the list of movies
    /// - Returns: All movies, optional filtered by watched state
    private func getMovies() -> [MediaItem] {
        return kodi.media.filter(MediaFilter(media: .movie)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
    }
    

}
