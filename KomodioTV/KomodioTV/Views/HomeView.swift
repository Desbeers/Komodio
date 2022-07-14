//
//  HomeView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//
import SwiftUI
import SwiftlyKodiAPI

/// The Home View for Komodio
struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    @State var movies: [Video.Details.Movie] = []
    @State var episodes: [Video.Details.Episode] = []
    
    @FocusState var selectedMovie: Video.Details.Movie?
    @FocusState var selectedEpisode: Video.Details.Episode?
    /// The body of this View
    var body: some View {
        ScrollView {
            // MARK: Unwatched movies
            Text("Unwatched Movies")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
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
                Text("\(selection.plot)")
                    .lineLimit(2)
                    .padding(.bottom, 40)
                    .padding(.horizontal, 80)
            }
            // MARK: Unwatched episodes
            Text("Unwatched episodes")
                .font(.title3)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(episodes) { episode in
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
        .edgesIgnoringSafeArea(.horizontal)
        .buttonStyle(.card)
        .animation(.default, value: selectedMovie)
        .animation(.default, value: selectedEpisode)
        .task(id: kodi.library.movies) {
            movies = Array(kodi.library.movies
                .filter { $0.playcount == 0 }
                .sorted { $0.dateAdded > $1.dateAdded }
                .prefix(10))
        }
        .task(id: kodi.library.episodes) {
            episodes = Array(kodi.library.episodes
                .filter { $0.playcount == 0 && $0.season != 0 }
                .sorted { $0.firstAired < $1.firstAired }
                .unique { $0.tvshowID }
                .sorted { $0.dateAdded > $1.dateAdded }
            )
        }
    }
}
