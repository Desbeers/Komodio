//
//  ShelfView.swift
//  Komodio
//
//  Created by Nick Berendsen on 22/12/2023.
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Shelf View

/// SwiftUI `View` for a shelf with media (shared)
struct ShelfView: View {
    /// The loading status of the `View`
    @State private var status: ViewStatus = .loading
    /// The itmes to show in the shelf
    @State private var items: [any KodiItem] = []
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The selected media for the shelf
    @AppStorage("shelfMedia") private var media: ShelfView.Media = .randomMovies

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
#if !os(tvOS)
            mediaPicker
                .pickerStyle(.segmented)
                .labelsHidden()
#endif
            Spacer()
            switch status {
            case .ready:
                content
                    .transition(.move(edge: .trailing))
            default:
                status.message(router: media.router, progress: true)
                    .backport.focusable()
            }
            Spacer()
            HStack {
#if os(tvOS)
                mediaPicker
                    .frame(width: 500)
                    .pickerStyle(.menu)
#endif
                StatisticsView()
            }
            .frame(maxWidth: .infinity)
            .backport.focusSection()
        }
        .frame(maxHeight: .infinity)
        .animation(.default, value: media)
        .animation(.default, value: status)
        .task {
            if items.isEmpty {
                items = getMedia
            }
            try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            status = items.isEmpty ? .empty : .ready
        }
        .onChange(of: media) {
            Task {
                scene.showInspector = false
                status = .loading
                items = getMedia
                try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                status = items.isEmpty ? .empty : .ready
            }
        }
        .id(items.map(\.id))
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.id) { movie in
                        CollectionView.Cell(item: movie, collectionStyle: .asGrid)
                            .padding(.vertical, StaticSetting.cellPadding)
                    }
                }
            }
        }
        .scrollClipDisabled(true)
    }
}


extension ShelfView {

    enum Media: String, CaseIterable {
        case randomMovies = "Random Movies"
        case unwatchedMovies = "Unwatched Movies"
        case unwatchedEpisodes = "Unwatched Episodes"

        var router: Router {
            switch self {
            case .randomMovies:
                .randomMovies
            case .unwatchedMovies:
                .unwatchedMovies
            case .unwatchedEpisodes:
                .unwachedEpisodes
            }
        }
    }
}

extension ShelfView {

    private var getMedia: [any KodiItem] {
        switch media {
        case.unwatchedMovies:
            Array(Set(kodi.library.movies.filter { $0.playcount == 0 }).prefix(20))
        case .unwatchedEpisodes:
            Array(Set(kodi.library.episodes.filter { $0.playcount == 0 }.uniqued(by: \.showTitle)).prefix(20))
        default:
            Array(Set(kodi.library.movies).prefix(20))
        }
    }
}

extension ShelfView {

    var mediaPicker: some View {
        Picker(selection: $media) {
            ForEach(Media.allCases, id: \.self) { media in
                Text(media.rawValue)
            }
        } label: {
            Text(media.rawValue)
        }
    }
}
