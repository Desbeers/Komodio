//
//  TVShowView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for one TV show
struct TVShowView: View {
    let tvshow: Video.Details.TVShow
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
        .background(
            KodiArt.Fanart(item: tvshow)
                .scaledToFill()
                .opacity(0.2)
        )
    }
}
