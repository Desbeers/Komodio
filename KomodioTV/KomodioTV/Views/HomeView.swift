//
//  HomeView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The Home View for Komodio
struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    @State var movies: [Video.Details.Movie] = []
    @State var episodes: [Video.Details.Episode] = []
    
    @State var shelf = Shelf()
    
    @FocusState var selectedMovie: Video.Details.Movie?
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.inProgress.movies) { movie in
                            MoviesView.MovieItem(movie: movie)
                                .padding(EdgeInsets(top: 40, leading: 0, bottom: 80, trailing: 0))
                        }
                        .scaleEffect(0.6)
                        ForEach(shelf.inProgress.episodes) { episode in
                            EpisodesView.Item(episode: episode)
                                .padding(EdgeInsets(top: 40, leading: 0, bottom: 80, trailing: 0))
                        }
                    }
                    .frame(height: 360)
                    .padding(.horizontal, 80)
                }
            }
            // MARK: Unwatched movies
            if !shelf.movies.isEmpty {
                Text("Unwatched Movies")
                    .font(.title3)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.movies) { movie in
                            MoviesView.MovieItem(movie: movie)
                                .padding(EdgeInsets(top: 40, leading: 0, bottom: 80, trailing: 0))
                                .focused($selectedMovie, equals: movie)
                        }
                    }
                    
                    .padding(.horizontal, 80)
                }
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shelf.episodes) { episode in
                            EpisodesView.Item(episode: episode)
                                .padding(EdgeInsets(top: 40, leading: 0, bottom: 80, trailing: 0))
                                .focused($selectedEpisode, equals: episode)
                        }
                    }
                    .padding(.horizontal, 80)
                }
                if let selection = selectedEpisode {
                    Text("\(selection.showTitle): season \(selection.season), episode \(selection.episode)")
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .buttonStyle(.card)
        .animation(.default, value: selectedMovie)
        .animation(.default, value: selectedEpisode)
        .task(id: kodi.library.movies) {
            shelf.movies = Array(kodi.library.movies
                .filter { $0.playcount == 0 && $0.resume.position == 0 }
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(10))
            shelf.inProgress.movies = Array(kodi.library.movies
                .filter { $0.resume.position != 0 }
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(10))
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
        }
    }
}

extension HomeView {
    
    struct Shelf {
        var movies: [Video.Details.Movie] = []
        var episodes: [Video.Details.Episode] = []
        
        var inProgress = InProgress()
    
        struct InProgress {
            var movies: [Video.Details.Movie] = []
            var episodes: [Video.Details.Episode] = []
        }
    }
}
