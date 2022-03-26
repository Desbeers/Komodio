//
//  ArtView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher

/// A collection of structs to view Kodi art
struct ArtView {
    /// Just a Namespace here...
}

extension ArtView {
    
    struct Fanart: View {
        let fanart: String
        var body: some View {
            KFImage(URL(string: fanart)!)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    struct Poster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            Group {
                if item.poster.isEmpty {
                    Image("No Poster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    KFImage(URL(string: item.poster)!)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    struct Episode: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            KFImage(URL(string: item.thumbnail.isEmpty ? item.poster : item.thumbnail)!)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
        }
    }
    struct Thumbnail: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            KFImage(URL(string: item.thumbnail.isEmpty ? item.poster : item.thumbnail)!)
                        .fade(duration: 0.25)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
        }
    }
    
}
