//
//  ArtView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher

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
                KFImage(URL(string: item.thumbnail))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320, height: 180)
            case .artist:
                KFImage(URL(string: item.thumbnail))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
            default:
                /// Just the 'standard' poster
                KFImage(URL(string: item.poster))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 450)
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
        let item: MediaItem?
        var body: some View {
            //if item != nil {
            if item?.fanart != nil {
                KFImage(URL(string: item!.fanart)!)
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(0.3)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            } else {
                EmptyView()
            }
        }
    }
}
