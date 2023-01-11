//
//  ArtistsView.swift
//  Komodio
//
//  © 2023 Nick Berendsen
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
    /// The optional selected artist in the list
    @State private var selectedArtist: Audio.Details.Artist?
    /// The selected artist
    @State private var artist = Audio.Details.Artist(media: .none)
    /// The loading state of the View
    @State private var state: Parts.Status = .loading
    /// Define the grid layout (tvOS)
    private let grid = [GridItem(.adaptive(minimum: 350))]

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .loading:
                Text(Router.musicVideos.loading)
            case .empty:
                Text(Router.musicVideos.empty)
            case .ready:
                content
            case .offline:
                state.offlineMessage
            }
        }
        .animation(.default, value: selectedArtist)
        .task(id: kodi.library.musicVideos) {
            if kodi.state != .loadedLibrary {
                state = .offline
            } else if kodi.library.musicVideos.isEmpty {
                state = .empty
            } else {
                getItems()
                state = .ready
            }
        }
        .task(id: selectedArtist) {
            setItemDetails()
        }
    }

    // MARK: Content of the View

#if os(macOS)
    /// The content of the view
    var content: some View {
        ZStack {
            List(selection: $selectedArtist) {
                ForEach(artists, id: \.id) { artist in
                    Item(artist: artist)
                        .tag(artist)
                }
            }
            .scaleEffect(selectedArtist != nil ? 0.6 : 1)
            .offset(x: selectedArtist != nil ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            MusicVideosView(artist: artist)
                .transition(.move(edge: .leading))
                .offset(x: selectedArtist != nil ? 0 : ContentView.columnWidth, y: 0)
        }
        .toolbar {
            if selectedArtist != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        selectedArtist = nil
                        artist = Audio.Details.Artist(media: .none)
                        scene.details = Router.musicVideos
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
    }
#endif

#if os(tvOS)
    /// The content of the view
    var content: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 0) {
                ForEach(artists) { artist in
                    NavigationLink(value: artist, label: {
                        Item(artist: artist)
                    })
                }
                .padding(.bottom, 40)
            }
        }
        .buttonStyle(.card)
        .padding(.horizontal, 80)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .setSafeAreas()
    }
#endif

    // MARK: Private functions

    /// Get all items from the library
    ///
    /// Movies that are part of a set will be removed and replaced with the set
    private func getItems() {
        var artistList: [Audio.Details.Artist] = []
        let allArtists = kodi.library.musicVideos.unique(by: {$0.artist}).flatMap({$0.artist})
        for artist in allArtists {
            artistList.append(artistItem(artist: artist))
        }
        artists = artistList
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedArtist {
            artist = selectedArtist
            scene.details = .artist(artist: selectedArtist)
        } else {
            scene.navigationSubtitle = Router.musicVideos.label.title
            artist = Audio.Details.Artist(media: .none)
        }
    }

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

// MARK: Extensions

extension ArtistsView {

    /// SwiftUI View for an artist in ``ArtistsView``
    struct Item: View {
        /// The artist
        let artist: Audio.Details.Artist
        /// The body of the View
        var body: some View {
#if os(macOS)
            HStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: KomodioApp.posterSize.width, height: KomodioApp.posterSize.width)
                VStack(alignment: .leading) {
                    Text(artist.artist)
                        .font(.headline)
                }
            }
#endif

#if os(tvOS)
            VStack {
                KodiArt.Poster(item: artist)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 360, height: 360)
                Text(artist.artist)
                    .font(.caption)
            }
#endif
        }
    }
}
