//
//  MoviesView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MoviesView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The movies in this view
    @State var videos: [any KodiItem] = []
    
    //@State private var selectedMovie: (any KodiItem)?
    //@State private var selectedVideo: VideoSelection?
    
    @State private var status: SceneState.Status = .movies
    

    
    var body: some View {
        ZStack {
            List(selection: $scene.selectedMedia) {
                ForEach(videos, id: \.id) { video in
                    
                    switch video {

                    case let movie as Video.Details.Movie:
                        Item(movie: movie)
                            .tag(SceneState.MediaSelection(id: movie.id, media: .movie))
                    case let movieSet as Video.Details.MovieSet:
                        MovieSetView.Item(movieSet: movieSet)
                            .tag(SceneState.MediaSelection(id: movieSet.id, media: .movieSet))
                    default:
                        EmptyView()
                    }
                }
            }
            .offset(x: status == .movieSet ? -400 : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            MovieSetView(status: $status, movieSet: $scene.selectedMovieSet)
                .transition(.move(edge: .leading))
                .offset(x: status == .movies ? 400 : 0, y: 0)
        }
        .navigationSubtitle(scene.selectedMovieSet != nil ? scene.selectedMovieSet!.title : "Movies")
        .animation(.default, value: status)
        .task(id: kodi.library.movies) {
            /// Remove all movies that are a part of a set and add the sets instead
            videos = (kodi.library.movies.filter({$0.setID == 0}) + kodi.library.movieSets).sorted(by: {$0.sortByTitle < $1.sortByTitle})
        }
        .task(id: scene.selectedMedia) {
            if let video = scene.selectedMedia {
                switch video.media {
                case .movie:
                    if let movie = kodi.library.movies.first(where: {$0.id == video.id}) {
                        scene.selectedMovie = movie
                        scene.selectedMovieSet = nil
                    }
                case .movieSet:
                    if let movieSet = kodi.library.movieSets.first(where: {$0.id == video.id}) {
                        scene.selectedMovie = nil
                        scene.selectedMovieSet = movieSet
                        status = .movieSet
                    }
                default:
                    break
                }
            } else {
                /// Reset the state
                scene.selectedMovie = nil
                scene.selectedMovieSet = nil
                status = .movies
            }
        }
    }
}

extension MoviesView {
    
    struct Item: View {
        let movie: Video.Details.Movie
        var body: some View {
            HStack {
                KodiArt.Poster(item: movie)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.genre.joined(separator: "∙"))
                    Text(movie.premiered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .watchStatus(of: movie)
            }
        }
    }
}

extension MoviesView {
    
    struct Details: View {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        var body: some View {
            VStack {
                if let movie = scene.selectedMovie {
                    VStack {
                        KodiArt.Fanart(item: movie)
                            .padding(.bottom, 40)
                        Text(movie.title)
                            .font(.largeTitle)
                        Text(movie.plot)
                        Buttons.Player(item: movie)
                    }
                    .padding(40)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(
                        KodiArt.Fanart(item: movie)
                            .scaledToFill()
                            .opacity(0.2)
                    )
                } else {
                    Text("Movies")
                        .font(.largeTitle)
                }
            }
            .animation(.default, value: scene.selectedMovie)
        }
    }
}
