//
//  MusicVideosView.swift
//  Komodio
//
//  Created by Nick Berendsen on 28/11/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for all Music Videos of an Artist; grouped by optional Album
struct MusicVideosView: View {
    /// The selected artist
    @Binding var artist: Audio.Details.Artist?
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The items to show in this view. Can be music video or album
    @State private var items: [MediaItem] = []
    /// The optional selected item
    @State private var selectedItem: MediaItem?
    /// The body of the view
    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                ForEach(items) { item in
                    Item(item: item)
                        .tag(item)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
        .toolbar {
            if artist != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        artist = nil
                        selectedItem = nil
                        scene.details = Router.musicVideos
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
        .task(id: artist) {
            getItems()
        }
        .task(id: kodi.library.musicVideos) {
            getItems()
            setItemDetails()
        }
        .task(id: selectedItem) {
            setItemDetails()
        }
    }
}

extension MusicVideosView {

    /// Get all items from the library
    private func getItems() {
        if let artist {
            var result: [MediaItem] = []
            let allMusicVideosFromArtist = kodi.library.musicVideos.filter({$0.artist.contains(artist.artist)})
            for video in allMusicVideosFromArtist.uniqueAlbum() {
                let albumMusicVideos = allMusicVideosFromArtist.filter({$0.album == video.album})
                let count = albumMusicVideos.count
                result.append(MediaItem(id: count == 1 ? video.id : video.album, media: count == 1 ? .musicVideo : .album, musicVideos: albumMusicVideos))
            }
            items = result
        }
        /// Update the optional selected item
        if let selectedItem {
            self.selectedItem = items.first(where: {$0.id == selectedItem.id})
        }
    }

    /// Set the details of a selected item
    private func setItemDetails() {
        if let selectedItem, let first = selectedItem.musicVideos?.first {
            switch selectedItem.media {
            case .musicVideo:
                scene.details = Router.musicVideo(musicVideo: first)
            case.album:
                scene.details = Router.album(album: selectedItem)
            default:
                break
            }
        }
    }
}

extension MusicVideosView {

    /// SwiftUI View for an item in ``MusicVideosView``
    struct Item: View {
        let item: MediaItem
        var body: some View {
            if let first = item.musicVideos?.first {
                HStack {
                    KodiArt.Poster(item: first)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 120)
                    Text(item.media == .musicVideo ? first.title : first.album)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .watchStatus(of: first)
            }
        }
    }
}
