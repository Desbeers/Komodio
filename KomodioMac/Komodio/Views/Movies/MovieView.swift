//
//  MovieView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MovieView: View {
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
