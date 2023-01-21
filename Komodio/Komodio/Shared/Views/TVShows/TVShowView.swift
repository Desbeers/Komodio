//
//  TVShowView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a single TV show (shared)
enum TVShowView {
    // Just a Namespace
}

extension TVShowView {

    // MARK: Details of a TV show

    /// SwiftUI View for TV show details
    struct Details: View {
        /// The TV show
        let tvshow: Video.Details.TVShow

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

#if os(macOS)
            ScrollView {
                VStack {
                    Text(tvshow.title)
                        .font(.system(size: 40))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    KodiArt.Fanart(item: tvshow)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                    Text(tvshow.plot)
                        .font(.system(size: 18))
                        .lineSpacing(8)
                        .padding(.vertical)
                }
                .padding(40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(item: tvshow)
#endif

#if os(tvOS)
            VStack {
                Text(tvshow.title)
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                KodiArt.Fanart(item: tvshow)
                    .cornerRadius(10)
                Text(tvshow.plot)
            }
            .padding(40)
            .background(item: tvshow)
#endif

        }
    }
}
