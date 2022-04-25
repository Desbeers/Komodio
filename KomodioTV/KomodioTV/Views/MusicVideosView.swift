//
//  MusicVideosView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The KodiConnector model
    //@EnvironmentObject var kodi: KodiConnector
    /// The artists to show
    @State private var artists: [MediaItem] = []
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 340))]
    /// The focused item
    @FocusState var selectedItem: MediaItem?
    /// The View
    var body: some View {
        VStack(spacing: 0 ) {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 0) {
                    ForEach(artists) { artist in
                        NavigationLink(destination: Artist(artist: artist)) {
                            VStack {
                                ArtView.Poster(item: artist)
                                Text(artist.title)
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.card)
                        .padding()
                        .focused($selectedItem, equals: artist)
                        .zIndex(artist == selectedItem ? 2 : 1)
                    }
                }
            }
        }
        .task {
            artists = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideoArtist))
        }
    }
}

extension MusicVideosView {
    struct Artist: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The artist who's videos to show
        let artist: MediaItem
        /// The items to show
        @State private var items: [MediaItem] = []
        /// The focused item
        @FocusState var selectedItem: MediaItem?
        /// Define the grid layout
        let grid = [GridItem(.adaptive(minimum: 300))]
        /// The View
        var body: some View {
            VStack {
                ScrollView {
                    LazyVGrid(columns: grid, spacing: 0) {
                        ForEach(items) { item in
                            Group {
                                if item.album.isEmpty {
                                    NavigationLink(destination: DetailsView(item: item)) {
                                        ArtView.Poster(item: item)
                                    }
                                } else {
                                    NavigationLink(destination: Album(album: item)) {
                                        ArtView.Poster(item: item)
                                    }
                                }
                            }
                            .buttonStyle(.card)
                            .padding()
                            .focused($selectedItem, equals: item)
                            .zIndex(item == selectedItem ? 2 : 1)
                        }
                    }
                }
            }
            .navigationTitle(artist.title)
            .task {
                items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: artist.artists))
            }
        }
    }
    
    struct Album: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The album who's videos to show
        let album: MediaItem
        /// The items to show
        @State private var items: [MediaItem] = []
        /// The focused item
        @FocusState var selectedItem: MediaItem?
        /// Define the grid layout
        let grid = [GridItem(.adaptive(minimum: 300))]
        /// The View
        var body: some View {
            VStack {
                ScrollView {
                    LazyVGrid(columns: grid, spacing: 0) {
                        ForEach(items) { item in
                            NavigationLink(destination: DetailsView(item: item)) {
                                VStack {
                                    ArtView.MusicVideoIcon(item: item)
                                    Text(item.title)
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.card)
                            .padding()
                            .focused($selectedItem, equals: item)
                            .zIndex(item == selectedItem ? 2 : 1)
                        }
                    }
                }
            }
            .navigationTitle(album.album)
            .task {
                items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: album.artists, album: album))
            }
        }
    }
}
