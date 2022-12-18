//
//  MovieView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a Movie
struct MovieView: View {
    /// The movie
    let movie: Video.Details.Movie
    /// The body of the view
    var body: some View {
        VStack {
            VStack {
                Text(movie.title)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                KodiArt.Fanart(item: movie)
                    .watchStatus(of: movie)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Buttons.Player(item: movie)
                Text(movie.plot)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                KodiArt.Fanart(item: movie)
                    .scaledToFill()
                    .opacity(0.2)
            )
        }
    }
}
