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

    // MARK: Private functions

    /// Update a Movie
    ///
    /// On `tvOS`, Movie details are shown in its own View so it needs to update itself when movie details are changed
    ///
    /// - Parameter movie: The movie to update
    /// - Returns: If update is found, the updated Movie, else `nil`
    static private func updateMovie(movie: Video.Details.Movie) -> Video.Details.Movie? {
        if let update = KodiConnector.shared.library.movies.first(where: {$0.id == movie.id}), update != movie {
            return update
        }
        return nil
    }
}

extension MovieView {

    // MARK: Movie item

    /// SwiftUI View for a Movie item
    struct Item: View {
        /// The movie
        let movie: Video.Details.Movie

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
                KodiArt.Poster(item: movie)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.height)
                    .watchStatus(of: movie)

#if os(macOS)
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(movie.genre.joined(separator: "∙"))
                    Text(movie.year.description)
                        .font(.caption)
                }
#endif

            }
        }
    }
}

extension MovieView {

    // MARK: Movie details

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
            VStack {
                PartsView.DetailHeader(title: movie.title)
                KodiArt.Fanart(item: movie)
                    .fanartStyle(item: movie, overlay: movie.tagline.isEmpty ? nil : movie.tagline)
                Buttons.Player(item: movie)
                    .padding()
                VStack(alignment: .leading) {
                    Text(movie.plot)
                        .padding(.bottom)
                    movieDetails
                }
            }
            .detailsFontStyle()
            .detailsWrapper()
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
                            Text("\(movie.year.description) ∙ \(Parts.secondsToTime(seconds: movie.duration))")
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
                Label("\(movie.year.description) ∙ \(Parts.secondsToTime(seconds: movie.duration))", systemImage: "calendar.badge.clock")
                Label(movie.details, systemImage: "info.circle.fill")
                if !movie.director.isEmpty {
                    Label("Directed by \(movie.director.joined(separator: " ∙ "))", systemImage: "list.bullet.clipboard.fill")
                }
                if !cast.isEmpty {
                    Label(cast, systemImage: "person.fill")
                }
            }
            .labelStyle(.detailLabel)
            .padding(.vertical)
        }
    }
}
