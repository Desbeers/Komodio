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
        let movieSet: Video.Details.MovieSet

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: KomodioApp.platform == .tvOS ? false : true,
                title: KomodioApp.platform == .macOS ? movieSet.title : nil
            ) {
                content
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
        }
    }
}
