//
//  EpisodeView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View with one episode
struct EpisodeView: View {
    /// The Episode
    let episode: Video.Details.Episode
    @State private var isPresented = false
    var body: some View {
        Button(action: {
            withAnimation {
                isPresented.toggle()
            }
        }, label: {
            HStack(spacing: 0) {
                KodiArt.Art(file: episode.thumbnail)
                    .watchStatus(of: episode)
                    .frame(width: 213, height: 120)
                    .cornerRadius(6)
                    .overlay(alignment: .bottom) {
                        Buttons.Player(item: episode)
                    }
                    .padding()
                VStack(alignment: .leading) {
                    Text(episode.title)
                    Text(episode.plot)
                        .font(.caption2)
                        .lineLimit(5)
                }
            }
        })
        .buttonStyle(.plain)
    }
}
