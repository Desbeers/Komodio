//
//  ArtistsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Artists from Music Videos
struct ArtistsView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The artists in this view
    @State var artists: [Audio.Details.Artist] = []
    /// The optional selected artist
    @State private var selectedArtist: Audio.Details.Artist?
    /// The body of the view
    var body: some View {
        ZStack {
            List(selection: $selectedArtist) {
                ForEach(artists, id: \.id) { artist in
                    Item(artist: artist)
                        .tag(artist)
                }
            }
            .offset(x: selectedArtist != nil ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            MusicVideosView(artist: $selectedArtist)
                .transition(.move(edge: .leading))
                .offset(x: selectedArtist != nil ? 0 : ContentView.columnWidth, y: 0)
        }
        .animation(.default, value: selectedArtist)
        .task(id: kodi.library.musicVideos) {
            var artistList: [Audio.Details.Artist] = []
            let allArtists = kodi.library.musicVideos.unique(by: {$0.artist.first}).flatMap({$0.artist})
            for artist in allArtists {
                artistList.append(artistItem(artist: artist))
            }
            artists = artistList
        }
        .task(id: selectedArtist) {
            if let selectedArtist {
                scene.details = Router.artist(artist: selectedArtist)
            } else {
                scene.navigationSubtitle = Router.musicVideos.label.title
            }
        }
    }
}

extension ArtistsView {
    
    /// Convert an 'artist' string to a `KodiItem`
    /// - Parameter artist: Name of the artist
    /// - Returns: A `KodiItem`
    func artistItem(artist: String) -> Audio.Details.Artist {
        if let artistDetails = KodiConnector.shared.library.artists.first(where: {$0.artist == artist}) {
            return artistDetails
        }
        /// Return an uknown artist
        return Audio.Details.Artist(media: .artist, artist: artist, artistID: Int.random(in: 1...1000))
    }
}

extension ArtistsView {
    
    /// SwiftUI View for an artist in ``ArtistsView``
    struct Item: View {
        let artist: Audio.Details.Artist
        var body: some View {
            HStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                VStack(alignment: .leading) {
                    Text(artist.artist)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
    }
}
