//
//  ArtView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher
import NukeUI

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
                LazyImage(source: item.thumbnail)
                    .frame(width: 480, height: 270)
//                KFImage(URL(string: item.thumbnail))
//                    .placeholder { Image(systemName: "film").resizable().padding() }
//                    //.fade(duration: 0.25)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 320, height: 180)
            case .artist:
                KFImage(URL(string: item.thumbnail))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
            default:
                /// Just the 'standard' poster
                LazyImage(source: item.poster)
                    .frame(width: 320, height: 480)
//                KFImage(URL(string: item.poster))
//                    .placeholder { Image(systemName: "film").resizable().padding() }
//                    //.fade(duration: 0.25)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 300, height: 450)
            }
        }
    }
    
    struct MusicVideoIcon: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
                KFImage(URL(string: item.thumbnail))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320, height: 180)
        }
    }
    
    struct Background: View {
        let fanart: String
        var body: some View {
            KFImage(URL(string: fanart)!)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    struct SelectionBackground: View {
        @Environment(\.colorScheme) var colorScheme
        let item: MediaItem?
        var body: some View {
            

            
            //if item != nil {
            if item?.fanart != nil {
                
                ZStack(alignment: .bottom) {
                
                AsyncImage(url: URL(string: item!.fanart)) { image in
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .ignoresSafeArea()
                .frame(width: 1920, height: 1080)
                .opacity(0.5)
                //.opacity(colorScheme == .dark ? 0.5 : 0.3)
                .id(item!.file)
            //}
//                    LinearGradient(stops: [
//                        .init(color: .clear, location: 0.5),
//                        .init(color: colorScheme == .dark ? .black.opacity(0.6) : .white.opacity(0.6), location: 0.7),
//                        .init(color: colorScheme == .dark ? .black.opacity(0.6) : .white.opacity(0.6), location: 1),
////                        .init(color: .secondary.opacity(0.6), location: 0.7),
////                        .init(color: .secondary, location: 1),
//                    ],
//                    startPoint: .top,
//                    endPoint: .bottom)
//                        .ignoresSafeArea()
                }
                
//                LazyImage(source: item!.fanart)
//                    .frame(width: 1920, height: 1080)
//                    //.blendMode(.screen)
//                    .opacity(colorScheme == .dark ? 0.5 : 0.3)
//                    .ignoresSafeArea()
//                    .id(item!.file)
                
//                KFImage(URL(string: item!.fanart)!)
//                    //.fade(duration: 0.25)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .ignoresSafeArea()
//                    .opacity(0.3)
//                    .transaction { transaction in
//                        transaction.animation = nil
//                    }
            } else {
                EmptyView()
            }
        }
    }
}
