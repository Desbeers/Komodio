//
//  MusicAlbumView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'MusicAlbum' SwiftUI View
struct MusicAlbumView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let album: Video.Details.MusicVideo
    @State var musicVideos: [Video.Details.MusicVideo] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 500))]
    var body: some View {
        VStack {
            ScrollView {
                Text(album.album)
                    .font(.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(musicVideos) { musicVideo in
                        Item(musicVideo: musicVideo)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
        .task(id: kodi.library.musicVideos) {
            musicVideos = kodi.library.musicVideos
                .filter({$0.artist == album.artist && $0.album == album.album})
                .sorted { $0.year < $1.year }
        }
    }
}

extension MusicAlbumView {
    
    /// A View with a music video album item
    struct Item: View {
        let musicVideo: Video.Details.MusicVideo
        @State private var isPresented = false
        var body: some View {
            
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                KodiArt.Art(file: musicVideo.art.icon)
                    .frame(width: 480, height: 270)
                    .watchStatus(of: musicVideo)
                    .itemOverlay(for: musicVideo, overlay: .title)
            })
            .buttonStyle(.card)
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: musicVideo)
            }
        }
    }
}
