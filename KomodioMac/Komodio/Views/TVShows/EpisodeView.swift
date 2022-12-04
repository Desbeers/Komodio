//
//  EpisodeView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for an Episode
struct EpisodeView: View {
    /// The Episode
    let episode: Video.Details.Episode
    /// The body of the view
    var body: some View {
        HStack(spacing: 0) {
            KodiArt.Art(file: episode.thumbnail)
                .watchStatus(of: episode)
                .frame(width: 213, height: 120)
                .cornerRadius(6)
                .padding()
            VStack(alignment: .leading) {
                Text(episode.title)
                    .font(.headline)
                Text(episode.plot)
                    .lineLimit(5)
                HStack {
                    Buttons.Player(item: episode)
                }
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
