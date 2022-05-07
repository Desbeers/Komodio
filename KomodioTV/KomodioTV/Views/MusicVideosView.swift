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
        .background(ArtView.SelectionBackground(item: selectedItem))
        .animation(.default, value: selectedItem)
        .task {
            artists = KodiConnector.shared.media.filter(MediaFilter(media: .musicVideoArtist))
        }
    }
}

extension MusicVideosView {
    
    /// A View for all music videos from one artist
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
        /// The View
        var body: some View {
            VStack {
                /// Header
                PartsView.Header(title: artist.title, subtitle: subtitle)
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
                //HStack {
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
                    
                    //Text(artist.description)
//                    if let selected = selectedItem {
//                        Text(selected.description)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
                //}
                //.frame(width: 200)
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
    
    struct Album: View {
//        /// The KodiConnector model
//        @EnvironmentObject var kodi: KodiConnector
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
