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

    /// SwiftUI View for the details of a `MovieSet`
    /// - Note: only used by macOS
    struct Details: View {
        /// The movie set
        let movieSet: Video.Details.MovieSet

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            DetailWrapper(title: movieSet.title) {
                VStack {
                    KodiArt.Fanart(item: movieSet)
                        .fanartStyle(item: movieSet)
                    Buttons.PlayedState(item: movieSet)
                        .padding()
                        .labelStyle(.playLabel)
                        .buttonStyle(.playButton)
                    Text(movieSet.plot)
                }
                .detailsFontStyle()
            }
        }
    }
}
