//
//  HomeView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Home' SwiftUI View
struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The items to show in this View
    @State var shelf = Shelf()
    /// The focussed movie
    @FocusState var selectedMovie: Video.Details.Movie?
    /// The focussed TV show
    @FocusState var selectedEpisode: Video.Details.Episode?
    /// The body of this View
    var body: some View {
        ScrollView {
            // MARK: In Progress
            if !shelf.inProgress.movies.isEmpty || !shelf.inProgress.episodes.isEmpty {
                Text("In progress...")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                    .padding(.horizontal, 60)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.inProgress.movies) { movie in
                            MoviesView.Item(movie: movie, size: .init(width: 150, height: 225), overlay: .timeToGo)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 80, trailing: 0))
                        }
                        ForEach(shelf.inProgress.episodes) { episode in
                            EpisodesView.Item(episode: episode, overlay: .timeToGo)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 80, trailing: 0))
                        }
                    }
                    .padding(.horizontal, 80)
                }
                .focusSection()
            }
            // MARK: Unwatched movies
            if !shelf.movies.isEmpty {
                Text("Unwatched Movies")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                    .padding(.horizontal, 60)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.movies) { movie in
                            MoviesView.Item(movie: movie)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 80, trailing: 0))
                                .focused($selectedMovie, equals: movie)
                        }
                    }
                    .padding(.horizontal, 80)
                }
                .focusSection()
                if let selection = selectedMovie {
                    Text("\(selection.plot)")
                        .lineLimit(2)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 80)
                }
            }
            // MARK: Unwatched episodes
            if !shelf.episodes.isEmpty {
                Text("Unwatched episodes")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                    .padding(.horizontal, 60)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.episodes) { episode in
                            EpisodesView.Item(episode: episode)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 80, trailing: 0))
                                .focused($selectedEpisode, equals: episode)
                        }
                    }
                    .padding(.horizontal, 80)
                }
                .focusSection()
                if let selection = selectedEpisode {
                    Text("\(selection.showTitle): season \(selection.season), episode \(selection.episode)")
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .animation(.default, value: selectedMovie)
        .animation(.default, value: selectedEpisode)
        .animation(.default, value: shelf.animate)
        .task(id: kodi.library.movies) {
            shelf.movies = Array(kodi.library.movies
                .filter { $0.playcount == 0 && $0.resume.position == 0 }
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(10))
            shelf.inProgress.movies = Array(kodi.library.movies
                .filter { $0.resume.position != 0 }
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(10))
            shelf.animate.toggle()
        }
        .task(id: kodi.library.episodes) {
            shelf.episodes = Array(kodi.library.episodes
                .filter { $0.playcount == 0 && $0.season != 0 && $0.resume.position == 0  }
                .sorted { $0.firstAired < $1.firstAired }
                .unique { $0.tvshowID }
                .sorted { $0.dateAdded > $1.dateAdded }
            )
            shelf.inProgress.episodes = Array(kodi.library.episodes
                .filter { $0.resume.position != 0  }
                .sorted { $0.firstAired < $1.firstAired }
                .unique { $0.tvshowID }
                .sorted { $0.dateAdded > $1.dateAdded }
            )
            shelf.animate.toggle()
        }
    }
}

extension HomeView {
    
    /// The items to show in this View
    struct Shelf {
        var movies: [Video.Details.Movie] = []
        var episodes: [Video.Details.Episode] = []
        var inProgress = InProgress()
        /// Dirty trick to get animations for this Struct
        var animate: Bool = false
        /// The 'in progress items
        struct InProgress {
            var movies: [Video.Details.Movie] = []
            var episodes: [Video.Details.Episode] = []
        }
    }
}
