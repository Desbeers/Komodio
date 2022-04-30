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
        /// The View
        var body: some View {
            VStack {
                if let selected = selectedItem {
                    Text(artist.title)
                        .font(.title)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(selected.album.isEmpty ? selected.title : selected.album)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach($items) { $item in
                            Group {
                                if item.album.isEmpty {
                                    NavigationLink(destination: DetailsView(item: $item)) {
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
                VStack {
                if let selected = selectedItem {
                    Text(selected.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                }
                .frame(height: 200)
            }
            .background(ArtView.SelectionBackground(item: selectedItem))
            .animation(.default, value: selectedItem)
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
                    Text(album.artists.joined(separator: " & "))
                            .font(.title)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    Text(album.album)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    LazyVGrid(columns: grid, spacing: 0) {
                        ForEach($items) { $item in
                            NavigationLink(destination: DetailsView(item: $item)) {
                                VStack {
                                    ArtView.MusicVideoIcon(item: item)
                                    Text(item.title)
                                        .font(.caption)
                                }
                                .watchStatus(of: $item)
                            }
                            .buttonStyle(.card)
                            .padding()
                            .focused($selectedItem, equals: item)
                            .zIndex(item == selectedItem ? 2 : 1)
                        }
                    }
                }
            }
            .task {
                items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: album.artists, album: album))
            }
        }
    }
}
