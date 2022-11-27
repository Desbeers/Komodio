//
//  EpisodeView.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
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
                    .frame(width: 320, height: 180)
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
