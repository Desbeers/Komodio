//
//  MusicVideoAlbumView+Details+ListItem.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension MusicVideoAlbumView.Details {

    // MARK: Album Item

    /// SwiftUI `View` for a `Music Video` list item in an `Album`
    struct ListItem: View {
        /// The `Music Video`
        let musicVideo: Video.Details.MusicVideo

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            HStack(spacing: 0) {
                KodiArt.Fanart(item: musicVideo)
                    .fanartStyle(item: musicVideo)
                    .frame(width: StaticSetting.thumbSize.width, height: StaticSetting.thumbSize.height)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(musicVideo.title)
                        .font(.title3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Rectangle().fill(.secondary).frame(height: 1)
                    Buttons.Player(item: musicVideo, fadeStateButton: true)
                }
            }
            .padding()
            .backport.focusSection()        }
    }
}
