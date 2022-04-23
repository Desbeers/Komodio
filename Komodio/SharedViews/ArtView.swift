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

    /// The background for the MainView
    struct Background: View {
        let fanart: String
        var body: some View {
            KFImage(URL(string: fanart)!)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
    
    struct Fanart: View {
        let fanart: String
        var body: some View {
            KFImage(URL(string: fanart)!)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    struct Poster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            
            switch item.media {
            case .artist:
                KFImage(URL(string: item.poster))
                    .placeholder { Image(systemName: "person").resizable().padding() }
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .macOS { $0.frame(width: 180, height: 180) }
                    .tvOS { $0.frame(width: 300, height: 300) }
                    .iOS { $0.frame(height: 200) }
            case .episode:
                KFImage(URL(string: item.thumbnail))
                    .placeholder { Image("No Poster").resizable() }
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .macOS { $0.frame(height: 100) }
                    .tvOS { $0.frame(height: 200) }
                    .iOS { $0.frame(height: 200) }
            case .musicVideo:
                /// This can be an actual Music Video or an album with Music Videos
                KFImage(URL(string: item.poster))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .macOS { $0.frame(width: 100, height: 150) }
                    .tvOS { $0.frame(width: 200, height: 300) }
                    .iOS { $0.frame(height: 200) }
            case .album:
                KFImage(URL(string: item.thumbnail.isEmpty ? item.poster : item.thumbnail)!)
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .macOS { $0.frame(width: 300, height: 300) }
                    .tvOS { $0.frame(width: 300, height: 300) }
                    .iOS { $0.frame(height: 200) }
            case .song:
                KFImage(URL(string: item.poster))
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.macOS { $0.frame(width: 300, height: 300) }
                    //.tvOS { $0.frame(width: 300, height: 300) }
                    //.iOS { $0.frame(height: 200) }
            default:
                /// Just the 'standard' poster
                KFImage(URL(string: item.poster))
                    .placeholder { Image(systemName: "film").resizable().padding() }
                    //.fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .macOS { $0.frame(width: 150, height: 225) }
                    .tvOS { $0.frame(width: 300, height: 450) }
                    .iOS { $0.frame(height: 200) }
            }
        }
    }

    struct DetailsPoster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            
            KFImage(URL(string: item.poster))
                .placeholder { Image(systemName: "person").resizable().padding() }
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .macOS { $0.frame(height: 200) }
                .tvOS { $0.frame(height: 240) }
                .iOS { $0.frame(height: 200) }
        }
        
    }

    struct MusicVideoIcon: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            KFImage(URL(string: item.thumbnail.isEmpty ? item.poster : item.thumbnail)!)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .macOS { $0.frame(width: 240) }
                .tvOS { $0.frame(width: 340) }
                .iOS { $0.frame(width: 240) }
        }
    }
    
    struct SeasonPoster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            KFImage(URL(string: item.poster))
                .placeholder { Image(systemName: "person").resizable().padding() }
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .macOS { $0.frame(width: 150, height: 225) }
                .tvOS { $0.frame(width: 400, height: 600) }
                .iOS { $0.frame(height: 200) }
        }
    }
    
    struct BasicPoster: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            KFImage(URL(string: item.poster))
                .placeholder { Image(systemName: "person").resizable().padding() }
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .macOS { $0.frame(height: 225) }
                .tvOS { $0.frame(height: 300) }
                .iOS { $0.frame(height: 200) }
        }
    }
}
