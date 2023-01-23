//
//  MovieView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single Movie (shared)
enum MovieView {

    /// Update a Movie
    /// - Parameter movie: The movie to update
    /// - Returns: If update is found, the updated Movie, else `nil`
    static func updateMovie(movie: Video.Details.Movie) -> Video.Details.Movie? {
        if let update = KodiConnector.shared.library.movies.first(where: {$0.id == movie.id}), update != movie {
            return update
        }
        return nil
    }
}

extension MovieView {

    // MARK: Details of a Movie

    /// SwiftUI View for Movie details
    struct Details: View {
        /// The Movie
        @State var movie: Video.Details.Movie
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The focus state of the Movie View (for tvOS)
        @FocusState var isFocused: Bool
        /// The cast of the Movie
        var cast: String {
            var cast: [String] = []
            for person in movie.cast {
                cast.append(person.name)
            }
            return cast.prefix(10).joined(separator: " ∙ ")
        }

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            content
                .background(item: movie)
                .task(id: kodi.library.movies) {
                    if let update = MovieView.updateMovie(movie: movie) {
                        movie = update
                    }
                }
                .focused($isFocused)
                .animation(.default, value: movie)
                .animation(.default, value: isFocused)
        }

        // MARK: Content of the View

        /// The content of the View
        @ViewBuilder var content: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(movie.title)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    HStack {
                        KodiArt.Fanart(item: movie)
                            .aspectRatio(contentMode: .fit)
                            .watchStatus(of: movie)
                            .overlay(alignment: .bottom) {
                                if !movie.tagline.isEmpty {
                                    Text(movie.tagline)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .padding(8)
                                        .frame(maxWidth: .infinity)
                                        .background(.regularMaterial)
                                }
                            }
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    Buttons.Player(item: movie)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(movie.plot)
                            .padding(.bottom)
                        movieDetails
                        Spacer()
                    }
                }
                .detailsFontStyle()
                .padding(40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
#endif

#if os(tvOS)
            ScrollView {
                VStack(spacing: 0) {
                    top
                        .frame(height: UIScreen.main.bounds.height)
                        .focusSection()
                    details
                        .frame(height: UIScreen.main.bounds.height)
                        .background(.black.opacity(0.8))
                }
                .foregroundColor(.white)
            }
            .ignoresSafeArea()
#endif
        }

#if os(tvOS)

        // MARK: tvOS Views

        /// SwiftUI View for the top of movie details
        var top: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5), .black.opacity(0.8)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .frame(height: 210)

                /// Top row
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Buttons.Player(item: movie, state: false)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(movie.title)
                                .font(.title2)
                                .lineLimit(1)
                            Text("\(movie.year.description) ∙ \(Parts.secondsToTime(seconds: movie.runtime))")
                                .font(.caption)
                                .opacity(0.6)
                        }
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, isFocused ? KomodioApp.sidebarCollapsedWidth : KomodioApp.sidebarWidth)
                }
                .padding(40)
                .frame(height: UIScreen.main.bounds.height)
                .focusSection()
            }
        }

        /// SwiftUI View for additional movie details
        var details: some View {
            HStack {
                KodiArt.Poster(item: movie)
                    .aspectRatio(contentMode: .fit)
                    .watchStatus(of: movie)
                    .padding(.leading)
                VStack(alignment: .leading) {
                    Spacer()
                    Text(movie.tagline.isEmpty ? movie.title : movie.tagline)
                        .font(.headline)
                        .padding(.bottom)
                    Text(movie.plot)
                        .padding(.bottom)
                    movieDetails
                    .labelStyle(Styles.DetailLabel())
                    Spacer()
                    Buttons.Player(item: movie)
                }
                .padding(40)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .focusSection()
            .padding(.leading, KomodioApp.sidebarCollapsedWidth)
        }
#endif

        /// The details of the movie
        var movieDetails: some View {
            VStack(alignment: .leading) {
                Label("\(movie.year.description) ∙ \(Parts.secondsToTime(seconds: movie.runtime))", systemImage: "calendar.badge.clock")
                Label(movie.details, systemImage: "info.circle.fill")
                if !movie.director.isEmpty {
                    Label("Directed by \(movie.director.joined(separator: " ∙ "))", systemImage: "list.bullet.clipboard.fill")
                }
                if !cast.isEmpty {
                    Label(cast, systemImage: "person.fill")
                }
            }
            .labelStyle(Styles.DetailLabel())
            .padding(.vertical)
        }
    }
}
