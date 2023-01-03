//
//  EpisodeView.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an Episode
struct EpisodeView: View {
    /// The Episode
    let episode: Video.Details.Episode
    /// The body of the View
    var body: some View {
        HStack(spacing: 0) {
            KodiArt.Art(file: episode.thumbnail)
                .watchStatus(of: episode)
                .frame(width: KomodioApp.thumbSize.width, height: KomodioApp.thumbSize.height)
                .cornerRadius(KomodioApp.thumbSize.width / 35)
                .padding()
            VStack(alignment: .leading) {
                Text(episode.title)
                    .font(.headline)
                Text(episode.plot)
                HStack {
                    Buttons.Player(item: episode)
                }
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .transition(.move(edge: .top))
        }
    }
}
