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

    /// SwiftUI `View` for details of a `Movie`
    struct Details: View {
        /// The `Movie` to show
        private let selectedMovie: Video.Details.Movie
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// The state values of the `Movie`
        @State private var movie: Video.Details.Movie
        /// Init the `View`
        init(movie: Video.Details.Movie) {
            self.selectedMovie = movie
            self._movie = State(initialValue: movie)
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            content
                .animation(.default, value: movie)
            /// Update the state to the new selection
                .task(id: selectedMovie) {
                    movie = selectedMovie
                }
            /// Update the state from the library
                .onChange(of: kodi.library.movies) { _ in
                    if let update = MovieView.update(movie: movie) {
                        movie = update
                    }
                }
        }

        // MARK: Content of the View

        /// The content of the `View`
        @ViewBuilder var content: some View {
#if os(macOS) || os(iOS) || os(visionOS)
            DetailView.Wrapper(
                scroll: StaticSetting.platform == .tvOS ? nil : movie.id,
                title: movie.title
            ) {
                VStack {
                    KodiArt.Fanart(item: movie)
                        .fanartStyle(item: movie, overlay: movie.tagline.isEmpty ? nil : movie.tagline)
#if os(visionOS)
                        .overlay(alignment: .topLeading) {
                            Buttons.Player(item: movie)
                                .padding()
                        }
#endif
#if !os(visionOS)
                    Buttons.Player(item: movie)
                        .padding()
#endif
                    VStack(alignment: .leading) {
                        Text(plot)
                            .padding(.bottom)
                        movieDetails
                    }
                    Pickers.RatingWidget(item: movie)
                }
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
            .animation(.default, value: scene.sidebarFocus)
#endif
        }

#if os(tvOS)

        // MARK: tvOS Views

        /// SwiftUI `View` for the top of movie details
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
                    .padding(
                        .leading,
                        scene.sidebarFocus ? StaticSetting.sidebarWidth : StaticSetting.sidebarCollapsedWidth
                    )
                }
                .padding(StaticSetting.detailPadding)
                .frame(height: UIScreen.main.bounds.height)
                .focusSection()
            }
        }

        /// SwiftUI `View` for additional movie details
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
                .padding(StaticSetting.detailPadding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .focusSection()
            .padding(.leading, StaticSetting.sidebarCollapsedWidth)
        }
#endif

        // MARK: Caculated stuff

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
                Label(movie.file, systemImage: "doc")
            }
            .labelStyle(.detailLabel)
        }
    }
}
