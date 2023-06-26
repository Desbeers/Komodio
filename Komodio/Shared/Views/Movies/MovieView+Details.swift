//
//  MovieView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MovieView {

    // MARK: Movie Details

    /// SwiftUI View for Movie details
    struct Details: View {
        /// The Movie
        @State var movie: Video.Details.Movie
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
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
        /// The plot of the Movie
        var plot: String {
            if !KodiConnector.shared.getKodiSetting(id: .videolibraryShowuUwatchedPlots)
                .list
                .contains(0) && movie.playcount == 0 {
                return "Plot is hidden for unwatched movies..."
            }
            return movie.plot
        }

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            content
                .task(id: kodi.library.movies) {
                    if let update = MovieView.updateMovie(movie: movie) {
                        movie = update
                    }
                    scene.selectedKodiItem = movie
                }
                .focused($isFocused)
                .animation(.default, value: movie)
                .animation(.default, value: isFocused)
        }

        // MARK: Content of the View

        /// The content of the View
        @ViewBuilder var content: some View {
#if os(macOS) || os(iOS)
            DetailWrapper(title: movie.title) {
                VStack {
                    KodiArt.Fanart(item: movie)
                        .fanartStyle(item: movie, overlay: movie.tagline.isEmpty ? nil : movie.tagline)
                    Buttons.Player(item: movie)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(plot)
                            .padding(.bottom)
                        movieDetails
                    }
                    Pickers.RatingWidget(item: movie)
                }
                .padding(.bottom)
                .detailsFontStyle()
            }
#endif

#if os(tvOS)
            ZStack {
                KodiArt.Fanart(item: movie)
                    .scaledToFill()
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
            }
            .ignoresSafeArea()
#endif
        }

#if os(tvOS)

        // MARK: tvOS Views

        /// SwiftUI View for the top of movie details
        var top: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(
                        colors: [.clear, .black.opacity(0.5), .black.opacity(0.8)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 210)
                /// Top row
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Buttons.Player(item: movie, showState: false)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(movie.title)
                                .font(.title2)
                                .lineLimit(1)
                            Text("\(movie.year.description) ∙ \(Utils.secondsToTimeString(seconds: movie.duration))")
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
                    Text(plot)
                        .padding(.bottom)
                    movieDetails
                    Spacer()
                    HStack {
                        Buttons.PlayedState(item: movie)
                        Pickers.RatingWidgetSheet(item: movie)
                    }
                    .labelStyle(.playLabel)
                    .buttonStyle(.playButton)
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
                Label(
                    "\(movie.year.description) ∙ \(Utils.secondsToTimeString(seconds: movie.duration))",
                    systemImage: "calendar.badge.clock"
                )
                Label(movie.details, systemImage: "info.circle.fill")
                if !movie.director.isEmpty {
                    Label(
                        "Directed by \(movie.director.joined(separator: " ∙ "))",
                        systemImage: "list.bullet.clipboard.fill"
                    )
                }
                if !cast.isEmpty {
                    Label(cast, systemImage: "person.fill")
                }
            }
            .labelStyle(.detailLabel)
        }
    }
}
