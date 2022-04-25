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
    /// The KodiConnector model
    //@EnvironmentObject var kodi: KodiConnector
    /// The movies to show
    @State private var movies: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// Hide watched
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// Init the View
    /// The View
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Button(action: {
                    hideWatched.toggle()
                }, label: {
                    Text(hideWatched ? "Show all movies" : "Hide watched")
                })
                Text("\(movies.count)" + (hideWatched ? " unwatched" : "") + " movies")
                    .font(.caption)
                if let item = selectedItem {
                    VStack {
                        Text(item.title)
                            .font(.headline)
                        Text(item.details)
                            .font(.caption)
                        Divider()
                        Text(item.description)
                            //.lineLimit(2)
                        if item.movieSetID != 0 {
                            
                            ForEach(KodiConnector.shared.media.filter { $0.media == .movie && $0.movieSetID == item.movieSetID}) { movie in
                                Label(movie.title, systemImage: "film")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .padding(1)
                    //.frame(maxWidth: .infinity)
                    
                }
            }
            .frame(width: 500)
            .focusSection()
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(movies) { movie in
                        Group {
                            if movie.movieSetID == 0 {
                                NavigationLink(destination: DetailsView(item: movie)) {
                                    ArtView.Poster(item: movie)
                                }
                            } else {
                                NavigationLink(destination: MovieSetView(set: movie)) {
                                    ArtView.Poster(item: movie)
                                }
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: movie)
                        .zIndex(movie == selectedItem ? 2 : 1)
                    }
                }
            }
        }
        .animation(.default, value: selectedItem)
        .animation(.default, value: hideWatched)
        .task {
            movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
        }
        .onChange(of: hideWatched) { _ in
            print("filter")
            movies = KodiConnector.shared.media.filter(MediaFilter(media: .movie)).filter { $0.playcount < (hideWatched ? 1 : 1000) }
        }
    }
}
