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
        let movie: Video.Details.Movie
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// The loading state of the View (tvOS)
        @State private var state: Parts.Status = .loading

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            content
        }

        // MARK: Content of the View

        /// The content of the `View`
        @ViewBuilder var content: some View {
#if os(macOS) || os(iOS)
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? false : true,
                title: movie.title
            ) {
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
            }
            /// Give it an ID so it will always scroll back to the top when selecting another movie
            .id(movie.id)
#endif

#if os(tvOS)
            Group {
                switch state {
                case .loading:
                    VStack {
                        Text(movie.title)
                            .font(.title)
                        ProgressView()
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .focusable()
                default:
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
                }
            }
            .ignoresSafeArea()
            .animation(.default, value: scene.sidebarFocus)
            .animation(.default, value: state)
            .transition(.slide)
            .task {
                try? await Task.sleep(until: .now + .seconds(2), clock: .continuous)
                state = .ready
            }
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
                    .padding(.leading, scene.sidebarFocus ? KomodioApp.sidebarWidth : KomodioApp.sidebarCollapsedWidth)
                }
                .padding(KomodioApp.contentPadding)
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
                .padding(KomodioApp.contentPadding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .focusSection()
            .padding(.leading, KomodioApp.sidebarCollapsedWidth)
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
