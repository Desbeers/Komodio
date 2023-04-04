//
//  SeasonView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Season View

/// SwiftUI View for one Season of a TV show (shared)
struct SeasonView: View {
    /// The TV show
    let tvshow: Video.Details.TVShow
    /// The Episodes to show
    let episodes: [Video.Details.Episode]
    /// The opacity of the View
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of this View
    var body: some View {
#if os(macOS)
        ScrollView {
            ScrollViewReader { proxy in
                PartsView.DetailHeader(
                    title: episodes.first?.season == 0 ? "Specials" : "Season \(episodes.first?.season ?? 1)"
                )
                .id(0)
                LazyVStack {
                    ForEach(episodes) { episode in
                        EpisodeView.Item(episode: episode)
                            .padding(.horizontal, 20)
                    }
                }
                .opacity(opacity)
                .task(id: episodes) {
                    withAnimation(.linear(duration: 1)) {
                        proxy.scrollTo(0, anchor: .top)
                    }
                    do {
                        opacity = 0
                        try await Task.sleep(until: .now + .seconds(0.5), clock: .continuous)
                        opacity = 1
                    } catch {}
                }
            }
        }
        .animation(.default, value: opacity)
#endif

#if os(tvOS)
        List {
            ForEach(episodes) { episode in
                EpisodeView.Item(episode: episode)
            }
        }
#endif
    }
}
