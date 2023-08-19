//
//  SwiftUIView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MovieSetView {

    // MARK: Movie Set Details

    /// SwiftUI `View` for details of a `MovieSet`
    struct Details: View {
        /// The `Movie Set` to show
        let selectedMovieSet: Video.Details.MovieSet
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The state values of the `Movie Set`
        @State private var movieSet: Video.Details.MovieSet
        /// Init the `View`
        init(movieSet: Video.Details.MovieSet) {
            self.selectedMovieSet = movieSet
            self._movieSet = State(initialValue: movieSet)
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: StaticSetting.platform == .tvOS ? nil : movieSet.id,
                title: StaticSetting.platform == .macOS ? movieSet.title : nil
            ) {
                content
                    .animation(.default, value: movieSet)
                /// Update the state to the new selection
                    .task(id: selectedMovieSet) {
                        movieSet = selectedMovieSet
                    }
                /// Update the state from the library
                    .onChange(of: kodi.library.movieSets) { _ in
                        if let update = MovieSetView.update(movieSet: movieSet) {
                            movieSet = update
                        }
                    }
            }
        }

        // MARK: Content of the View

        /// The content of the `View`
        var content: some View {
            VStack {
                KodiArt.Fanart(item: movieSet)
                    .fanartStyle(item: movieSet)
                Buttons.PlayedState(item: movieSet)
                    .padding()
                    .labelStyle(.playLabel)
                    .buttonStyle(.playButton)
                Text(movieSet.plot)
            }
            .padding(.bottom)
        }
    }
}
