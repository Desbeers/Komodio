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
    /// The videos in this view (movies + movie sets)
    @State var videos: [any KodiItem] = []
    /// The body of this view
    var body: some View {
        ZStack {
            List(selection: $scene.selection.mediaItem) {
                ForEach(videos, id: \.id) { video in
                    switch video {
                    case let movie as Video.Details.Movie:
                        Item(movie: movie)
                            .tag(MediaItem(id: movie.id, media: .movie))
                    case let movieSet as Video.Details.MovieSet:
                        MovieSetView.Item(movieSet: movieSet)
                            .tag(MediaItem(id: movieSet.id, media: .movieSet))
                    default:
                        EmptyView()
                    }
                }
            }
            .offset(x: scene.selection.route == .movieSet ? -400 : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            MovieSetView()
                .offset(x: scene.selection.route == .movieSet ? 0 : 400, y: 0)
        }
        .navigationSubtitle(scene.selection.movieSet != nil ? scene.selection.movieSet!.title : "Movies")
        .animation(.default, value: scene.selection.route)
        .task(id: kodi.library.movies) {
            /// Remove all movies that are a part of a set and add the sets instead
            videos = (kodi.library.movies.filter({$0.setID == 0}) + kodi.library.movieSets).sorted(by: {$0.sortByTitle < $1.sortByTitle})
            scene.selection.route = .movies
        }
        .task(id: scene.selection.mediaItem) {
            if let video = scene.selection.mediaItem {
                switch video.media {
                case .movie:
                    if let movie = kodi.library.movies.first(where: {$0.id == video.id}) {
                        scene.selection = SceneState.Selection(route: .movies, mediaItem: video, movie: movie, movieSet: nil)
                    }
                case .movieSet:
                    if let movieSet = kodi.library.movieSets.first(where: {$0.id == video.id}) {
                        scene.selection = SceneState.Selection(route: .movieSet, movie: nil, movieSet: movieSet)
                    }
                default:
                    break
                }
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
        /// The movie
        let movie: Video.Details.Movie
        var body: some View {
            VStack {
                VStack {
                    Text(movie.title)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: movie)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                    Text(movie.plot)
                }
                .padding(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .overlay(alignment: .bottom) {
                    Buttons.Player(item: movie)
                        .padding(40)
                }
                .background(
                    KodiArt.Fanart(item: movie)
                        .scaledToFill()
                        .opacity(0.2)
                )
            }
        }
    }
}
