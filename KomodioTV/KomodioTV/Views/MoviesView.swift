//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for Movie items
struct MoviesView: View {
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// Hide watched
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The View
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
                /// - Note: Don't animate the button
                .transaction { transaction in
                    transaction.animation = nil
                }
                Text("\(movies.count)" + (hideWatched ? " unwatched" : "") + " movies")
                    .font(.caption)
                    .foregroundColor(.secondary)
                // MARK: Show selected item info
                if let item = selectedItem {
                    VStack {
                        Text(item.title)
                            .font(.headline)
                        Text(item.details)
                            .font(.caption)
                        Divider()
                        Text(item.description)
                        /// If the item is a set; list all movies that is part of this set
                        if item.movieSetID != 0 {
                            ForEach(KodiConnector.shared.media.filter { $0.media == .movie && $0.movieSetID == item.movieSetID}) { movie in
                                Label(movie.title, systemImage: "film")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
            }
            .frame(width: 500)
            .focusSection()
            // MARK: Movie Grid
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach($movies) { $movie in
                        Group {
                            if movie.movieSetID == 0 {
                                NavigationLink(destination: DetailsView(item: $movie)) {
                                    ArtView.Poster(item: movie)
                                        .watchStatus(of: $movie)
                                }
                            } else {
                                NavigationLink(destination: MovieSetView(set: movie)) {
                                    ArtView.Poster(item: movie)
                                        .watchStatus(of: $movie)
                                }
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        /// - Note: Context Menu must go after the Button Style or else it does not work...
                        .contextMenu(for: $movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
                /// Don't animate the grid; posters will 'fly'...
                .transaction { transaction in
                    transaction.animation = nil
                }
            }
        }
        .animation(.default, value: selectedItem)
        .task {
            movies = getMovies()
        }
        .onChange(of: hideWatched) { _ in
            movies = getMovies()
        }
        .modifier(ViewModifierSelection(selectedItem: selectedItem))
    }
    
    /// Get the list of movies
    /// - Returns: All movies, optional filtered by watched state
    private func getMovies() -> [MediaItem] {
        return KodiConnector.shared.media.filter(MediaFilter(media: .movie)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
    }
}
