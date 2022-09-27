//
//  ArtistsView.swift
//  KomodioTV
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
    private let grid = [GridItem(.adaptive(minimum: 340))]
    /// The loading state of the view
    @State private var state: AppState.State = .loading
    /// Hide watched items toggle
    @AppStorage("hideWatched") private var hideWatched: Bool = false
    /// The body of this View
    var body: some View {
        VStack {
            VStack {
                switch state {
                case .loading:
                    Text("Loading your music videos")
                case .empty:
                    Text("There are no music videos in your library")
                case .ready:
                    content
                case .offline:
                    state.offlineMessage
                }
            }
        }
        .task(id: kodi.library.musicVideos) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.musicVideos.isEmpty {
                state = .empty
            } else {
                artists = kodi.library.musicVideos.unique(by: {$0.artist.first}).flatMap({$0.artist})
                state = .ready
            }
        }
    }
    /// The content of this View
    var content: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(artists, id: \.self) { artist in
                    ArtistItem(artist: artist)
                        .buttonStyle(.card)
                        .padding(.bottom, 40)
                }
            }
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
                            .frame(width: 300, height: 300)
                    } else {
                        Image(systemName: "music.quarternote.3")
                            .resizable()
                            .padding(80)
                            .frame(width: 300, height: 300)
                    }
                    Text(artist)
                        .font(.caption)
                        .padding(.bottom)
                }
            }
        }
    }
}
