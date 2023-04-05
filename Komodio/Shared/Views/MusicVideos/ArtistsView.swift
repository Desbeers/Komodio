//
//  ArtistsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Artists View

/// SwiftUI View for all Artists from Music Videos (shared)
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
    /// The opacity of the View
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            switch state {
            case .ready:
                content
            default:
                PartsView.StatusMessage(item: .musicVideos, status: state)
            }
        }
        .task {
            opacity = 1
        }
        .animation(.default, value: selectedArtist)
        .task(id: kodi.library.musicVideos) {
            if kodi.status != .loadedLibrary {
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
        ScrollView {
            LazyVStack {
                ForEach(artists) { artist in
                    NavigationLink(value: artist, label: {
                        ArtistView.Item(artist: artist)
                    })
                    .buttonStyle(.listButton(selected: false))
                    Divider()
                }
            }
            .padding()
        }
        .navigationStackAnimation(opacity: $opacity)
    }
#endif

#if os(tvOS)
    /// The content of the view
    var content: some View {
        ContentWrapper(
            header: {
                PartsView.DetailHeader(
                    title: Router.musicVideos.label.title,
                    subtitle: Router.musicVideos.label.description
                )
            },
            content: {
                LazyVGrid(columns: KomodioApp.grid, spacing: 0) {
                    ForEach(artists) { artist in
                        NavigationLink(value: artist, label: {
                            ArtistView.Item(artist: artist)
                        })
                    }
                    .padding(.bottom, 40)
                }
            })
        .buttonStyle(.card)
    }
#endif

    // MARK: Private functions

    /// Get all artists from the library
    private func getItems() {
        var artistList: [Audio.Details.Artist] = []
        let allArtists = kodi.library.musicVideos
            .unique { $0.artist }.flatMap { $0.artist }
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
            scene.navigationSubtitle = Router.musicVideos.label.description
            artist = Audio.Details.Artist(media: .none)
        }
    }

    /// Convert an 'artist' string to a `Audio.Details.Artist`
    /// - Parameter artist: Name of the artist
    /// - Returns: An `Audio.Details.Artist`
    private func artistItem(artist: String) -> Audio.Details.Artist {
        if let artistDetails = KodiConnector.shared.library.artists.first(where: { $0.artist == artist }) {
            return artistDetails
        }
        /// Return an uknown artist
        return Audio.Details.Artist(media: .artist, artist: artist, artistID: UUID().hashValue)
    }
}
