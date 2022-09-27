//
//  MusicVideosView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let artist: String
    @State var musicVideos: [Video.Details.MusicVideo] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 300))]
    var body: some View {
        VStack {
            ScrollView {
                Text(artist)
                    .font(.title)
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(musicVideos) { musicVideo in
                        if musicVideo.album.isEmpty {
                            Item(musicVideo: musicVideo)
                                .padding(.bottom, 40)
                        } else {
                            Album(album: musicVideo)
                                .padding(.bottom, 40)
                        }
                    }
                }
                .buttonStyle(.card)
            }
        }
        .task(id: kodi.library.musicVideos) {
            musicVideos = kodi.library.musicVideos
                .filter({$0.artist.contains(artist)}).uniqueAlbum()
                .sorted { $0.year < $1.year }
        }
    }
}

extension MusicVideosView {
    struct Item: View {
        let musicVideo: Video.Details.MusicVideo
        @State private var isPresented = false
        var body: some View {
            
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                KodiArt.Poster(item: musicVideo)
                    .frame(width: 300, height: 450)
                    .watchStatus(of: musicVideo)
            })
            .fullScreenCover(isPresented: $isPresented) {
                DetailsView(item: musicVideo)
            }
        }
    }
    
    struct Album: View {
        let album: Video.Details.MusicVideo
        var body: some View {
            NavigationLink(destination: MusicAlbumView(album: album)) {
                KodiArt.Poster(item: album)
                    .frame(width: 300, height: 450)
            }
        }
    }
}
