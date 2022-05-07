//
//  ArtView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of structs to view Kodi art
struct ArtView {
    /// Just a Namespace here...
}

extension ArtView {
    struct Poster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            switch item.media {
            case .episode:
                AsyncImage(url: URL(string: item.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 480, height: 270)
                } placeholder: {
                    Color.black
                        .frame(width: 480, height: 270)
                }
            case .artist:
                AsyncImage(url: URL(string: item.thumbnail)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                } placeholder: {
                    Color.black
                        .frame(width: 300, height: 300)
                }
            default:
                /// Just the 'standard' poster
                AsyncImage(url: URL(string: item.poster)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320, height: 480)
                } placeholder: {
                    Color.black
                        .frame(width: 320, height: 480)
                }
            }
        }
    }
    
    struct MusicVideoIcon: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            AsyncImage(url: URL(string: item.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320, height: 180)
            } placeholder: {
                Color.black
                    .frame(width: 320, height: 180)
            }
        }
    }
    
    struct ActorIcon: View {
        /// The Kodi item actor
        let item: String
        /// The View
        var body: some View {
            AsyncImage(url: URL(string: item)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
            } placeholder: {
                Color.black
                    .frame(width: 180, height: 180)
            }
        }
    }
    
    struct SelectionBackground: View {
        let item: MediaItem?
        var body: some View {
            Group {
            if item?.fanart != nil {
                ZStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: item!.fanart)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 1920, height: 1080)
                            //.opacity(0.5)
                            //.id(item!.file)
                    } placeholder: {
                        Color.black
                    }
                    .ignoresSafeArea()
                    
                }
            } else {
                Color.black.ignoresSafeArea()
            }
            }
            .overlay(.ultraThinMaterial)
        }
    }
}
