//
//  MovieView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

enum MovieView {

    static func updateMovie(movie: Video.Details.Movie) -> Video.Details.Movie? {
        if let update = KodiConnector.shared.library.movies.first(where: {$0.id == movie.id}), update != movie {
            return update
        }
        return nil
    }

}

extension MovieView {

    /// SwiftUI View for a Movie details
    struct Details: View {
        /// The movie
        @State var movie: Video.Details.Movie
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The body of the View
        var body: some View {
            VStack {
                Text(movie.title)
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(movie.details)
                KodiArt.Fanart(item: movie)
                    .watchStatus(of: movie)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                Buttons.Player(item: movie)
                Text(movie.plot)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            #if os(macOS)
            .background(
                KodiArt.Fanart(item: movie)
                    .scaledToFill()
                    .opacity(0.2)
            )
            #endif
            .task(id: kodi.library.movies) {
                if let update = MovieView.updateMovie(movie: movie) {
                    print("Update")
                    movie = update
                }
            }
            .animation(.default, value: movie)
            .shadow(radius: 0)
        }
    }
}
