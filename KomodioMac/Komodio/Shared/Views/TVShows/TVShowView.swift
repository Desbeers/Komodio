//
//  TVShowView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for a TV show
struct TVShowView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The body of the View
    var body: some View {
        VStack {
            KodiArt.Fanart(item: tvshow)
                .padding(.bottom, 40)
            Text(tvshow.title)
                .font(.largeTitle)
            Text(tvshow.plot)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
#if os(macOS)
        .background(
            KodiArt.Fanart(item: tvshow)
                .opacity(0.2)
                .scaledToFill()
        )
#endif
    }
}
