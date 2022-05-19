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
    struct HorizontalStrip: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            AsyncImage(url: URL(string: item.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 240)
            } placeholder: {
                Color.black
                    .frame(width: 160, height: 240)
            }
        }
    }
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
                        .frame(width: 400, height: 225)
                } placeholder: {
                    Color.black
                        .frame(width: 400, height: 225)
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
    

    
    struct SelectionBackground: View {
        let item: MediaItem?
        var body: some View {
            Group {
                if let fanart = item?.fanart {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: fanart)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                        } placeholder: {
                            Color.black
                        }
                        //.ignoresSafeArea()
                        
                    }
                } else {
                    Color.clear
                }
            }
            .blur(radius: 25, opaque: false)
            .opacity(0.5)
            .frame(width: 1920, height: 1080)
            .ignoresSafeArea()
            /// Give it an id so it will fade the fanart in and out
            .id(item)
            .animation(.default, value: item)
        }
    }
}
