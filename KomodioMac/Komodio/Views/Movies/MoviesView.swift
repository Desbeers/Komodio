//
//  MoviesView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Movies
///
/// Movies that are part of a set will be removed and replaced with the set
struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The items in this view (movies + movie sets)
    @State private var items: [any KodiItem] = []
    /// The optional filter
    var filter: Parts.Filter?
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// The loading state of the view
    @State private var state: Parts.State = .loading
    /// The body of the view
    var body: some View {
        VStack {
            switch state {
            case .loading:
                Text(Router.movies.loading)
            case .empty:
                Text(Router.movies.empty)
            case .ready:
                content
            case .offline:
                state.offlineMessage
            }
        }
        .animation(.default, value: selectedItem)
        .task(id: kodi.library.movies) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.movies.isEmpty {
                state = .empty
            } else {
                getItems()
                setItemDetails()
                state = .ready
            }
        }
        .task(id: selectedItem) {
            setItemDetails()
        }
    }
    /// The content of the view
    var content: some View {
        ZStack {
            List(selection: $selectedItem) {
                ForEach(items, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        Item(movie: movie)
                            .tag(MediaItem(id: movie.id, media: .movie))
                    case let movieSet as Video.Details.MovieSet:
                        MovieSetView.Item(movieSet: movieSet)
                            .tag(MediaItem(id: String(movieSet.setID), media: .movieSet))
                    default:
                        EmptyView()
                    }
                }
            }
            .offset(x: selectedItem?.media == .movieSet ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            MovieSetView(selectedSet: $selectedItem)
                .offset(x: selectedItem?.media == .movieSet ? 0 : ContentView.columnWidth, y: 0)
        }
    }
    
    /// Get all items from the library
    ///
    /// Movies that are part of a set will be removed and replaced with the set
    private func getItems() {
        var items: [any KodiItem] = []
        items = (kodi.library.movies.filter({$0.setID == 0}) + kodi.library.movieSets).sorted(by: {$0.sortByTitle < $1.sortByTitle})
        if let filter {
            switch filter {
            case .unwatched:
                items = items.filter({$0.playcount == 0})
            default:
                break
            }
        }
        self.items = items
    }
    
    /// Set the details of a selected item
    private func setItemDetails() {
        if let item = selectedItem {
            switch item.media {
            case .movie:
                if let movie = kodi.library.movies.first(where: {$0.id == item.id}) {
                    scene.details = .movie(movie: movie)
                }
            case .movieSet:
                if let movieSet = kodi.library.movieSets.first(where: {$0.setID == Int(item.id)}) {
                    scene.details = .movieSet(movieSet: movieSet)
                }
            default:
                break
            }
        } else {
            /// Set the default Navigation Subtitle for Movies
            if filter != nil {
                scene.navigationSubtitle = "Unwatched Movies"
            } else {
                scene.navigationSubtitle = Router.movies.label.title
            }
        }
    }
}

extension MoviesView {
    
    /// SwiftUI View for a movie in ``MoviesView``
    struct Item: View {
        /// The movie
        let movie: Video.Details.Movie
        /// The body of the view
        var body: some View {
            HStack {
                KodiArt.Poster(item: movie)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.genre.joined(separator: "∙"))
                    Text(movie.year.description)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .watchStatus(of: movie)
            }
        }
    }
}
