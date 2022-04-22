//
//  ArtistsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for Artists for Audio and Music Videos
struct ArtistsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The artists to show
    private var artists: [MediaItem]
    /// The type of media, audio or video
    private let media: MediaType
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 340))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 180))]
#endif
    init(media: MediaType) {
        self.media = media
        artists = KodiConnector.shared.media.filter(MediaFilter(media: media))
    }
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(artists) { artist in
                        RouterLink(item: media == .musicVideoArtist ? .musicVideosItems(artist: artist) : .albums(artist: artist)) {
                            Item(artist: artist)
                        }
                        .buttonStyle(ButtonStyles.MediaItem(item: artist))
                    }
                }
                .macOS { $0.padding(.horizontal, 20) }
                .tvOS { $0.padding(.horizontal, 80) }
            }
//            /// Make room for the details
//            .macOS { $0.padding(.leading, 330) }
//            .tvOS { $0.padding(.leading, 550) }
//            .iOS { $0.padding(.leading, 330) }
//            if router.selectedMediaItem != nil {
//                ItemsView.Details(item: router.selectedMediaItem!)
//            }
        }
        .animation(.default, value: router.selectedMediaItem)
//        .task {
//            if router.selectedMediaItem == nil {
//                router.setSelectedMediaItem(item: artists.first)
//            }
//        }
    }
}

extension ArtistsView {
    /// A View for one Artist Item
    struct Item: View {
        let artist: MediaItem
        var body: some View {
            VStack(spacing: 0) {
                ArtView.Poster(item: artist)
                Text(artist.title)
                    .font(.caption)
            }
        }
    }
}
