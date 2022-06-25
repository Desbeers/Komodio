//
//  MusicVideosView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A View for Music Videos
struct MusicVideosView: View {
    /// The artists to show
    @State private var artists: [MediaItem] = []
    /// Define the grid layout
    private let grid = [GridItem(.adaptive(minimum: 340))]
    /// The focused media item
    @FocusState private var selectedItem: MediaItem?
    /// The body of this View
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: grid) {
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
        .setSelection(of: selectedItem)
        .animation(.default, value: selectedItem)
        .task {
            artists = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideoArtist))
        }
    }
}

extension MusicVideosView {
    
    /// A View for all music items from one artist
    ///
    /// - An item can be a video or a link to an album
    struct Artist: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The artist who's videos to show
        let artist: MediaItem
        /// The items to show
        @State private var items: [MediaItem] = []
        /// The focused item
        @FocusState var selectedItem: MediaItem?
        /// The subtitle for this View
        var subtitle: String? {
            if let subtitle = selectedItem {
                switch subtitle.media {
                case .artist:
                    return "Artist details"
                default:
                    return subtitle.album.isEmpty ? subtitle.title : subtitle.album
                }
            }
            return nil
        }
        /// Show details
        @State var showDetail: Bool = false
        /// The body of this View
        var body: some View {
            VStack {
                /// Header
                PartsView.Header(title: artist.title, subtitle: subtitle)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach($items) { $item in
                            /// - Note: `NavigationLink` is in a `Group` because it cannot have a 'dynamic' destination
                            Group {
                                if item.album.isEmpty {
                                    NavigationLink(destination: DetailsView(item: $item)) {
                                        ArtView.Poster(item: item)
                                            .watchStatus(of: $item)
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
                if !artist.description.isEmpty {
                    Button(action: {
                        showDetail.toggle()
                    }, label: {
                        Text(artist.description)
                            .lineLimit(2)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 160)
                    })
                    .focused($selectedItem, equals: artist)
                    .buttonStyle(.card)
                }
            }
            .background(ArtView.SelectionBackground(item: artist))
            .animation(.default, value: selectedItem)
            .fullScreenCover(isPresented: $showDetail) {
                Text(artist.description)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.thinMaterial)
            }
            .task {
                items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: artist.artists))
            }
        }
    }
    
    /// A View to show a Music Album
    struct Album: View {
        /// The album who's videos to show
        let album: MediaItem
        /// The items to show
        @State private var items: [MediaItem] = []
        /// The focused item
        @FocusState var selectedItem: MediaItem?
        /// Define the grid layout
        let grid = [GridItem(.adaptive(minimum: 300))]
        /// The body of this View
        var body: some View {
            VStack {
                ScrollView {
                    /// Header
                    PartsView.Header(title: album.artists.joined(separator: " & "), subtitle: album.album)
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
            .background(ArtView.SelectionBackground(item: album))
            .animation(.default, value: selectedItem)
            .task {
                items = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideo, artist: album.artists, album: album))
            }
        }
    }
}
