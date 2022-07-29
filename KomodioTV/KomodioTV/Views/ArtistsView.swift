//
//  MoviesView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A SwiftUI View for TV show items
struct ArtistsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The artists to show; loaded by a 'Task'.
    @State private var artists: [String] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 540))]
    /// The focused item
    //@FocusState private var selectedItem: MediaItem?
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The body of this View
    var body: some View {
        //VStack {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(artists, id: \.self) { artist in
                        ArtistItem(artist: artist)
                            .buttonStyle(.card)
                            .padding(.bottom, 40)
                    }
                }
                //.padding(.vertical, 100)
            }
        //}
        //.ignoresSafeArea(.all)
        .task(id: kodi.library.musicVideos) {
            print("VIDEO TASK")
            print(kodi.library.musicVideos.count)
            artists = kodi.library.musicVideos.unique(by: {$0.artist.first}).flatMap({$0.artist})
//            //let musicArtists = kodi.library.musicVideos.unique(by: {$0.artist.first}).map({$0.artist})
//            let musicArtists = kodi.library.musicVideos.unique(by: {$0.artist.first}).flatMap({$0.artist})
//            artists = kodi.library.artists.filter({musicArtists.contains($0.artist)})
//            dump(musicArtists)
        }
    }
}

extension ArtistsView {
    
    struct ArtistItem: View {
        let artist: String
        var body: some View {
            NavigationLink(destination: MusicVideosView(artist: artist)) {
                VStack {
                    
                    if let artistDetails = KodiConnector.shared.library.artists.first(where: {$0.artist == artist}) {
                        
                        KodiArt.Poster(item: artistDetails)
                            .frame(width: 500, height: 500)
                    } else {
                        Image(systemName: "music.quarternote.3")
                            .resizable()
                            .padding(80)
                            .frame(width: 500, height: 500)
                    }
                    Text(artist)
                }
            }
        }
    }
}
