//
//  ArtistsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct ArtistsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 300))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 150))]
#endif
    /// The View
    var body: some View {
        ZStack(alignment: .topLeading) {
            ItemsView.List {
                LazyVGrid(columns: grid, spacing: 30) {
                    ForEach(kodi.media.filter(MediaFilter(media: .artist))) { artist in
                        //HStack {
                        RouterLink(item: .albums(artist: artist)) {
                            VStack(spacing: 0) {
                                ArtView.Poster(item: artist)
                                    .macOS { $0.frame(height: 150) }
                                    .tvOS { $0.frame(width: 300, height: 300) }
                                    .iOS { $0.frame(height: 200) }
                                Text(artist.title)
                                    .font(.caption)
                            }
                        }
                        .frame(width: 300)
                        .buttonStyle(ButtonStyles.MediaItem(item: artist))
                    }
                }
            }
            .padding(.leading, 500)
            .macOS { $0.padding(.top, 40) }
            //.tvOS { $0.padding(.horizontal, 100) }
            if router.selectedMediaItem != nil {
                Text(router.selectedMediaItem?.description ?? "Description")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .macOS { $0.frame(width: 300, height: 200) }
                    .tvOS { $0.frame(width: 500, height: 300) }
                    .iOS { $0.frame(width: 300, height: 300) }
                    .transition(.opacity)
                    .padding(.bottom)
                    .zIndex(1)
                    .padding(.top, 300)
                    .transition(.slide)
            }
        }
        .animation(.default, value: router.selectedMediaItem)
    }
}
