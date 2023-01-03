//
//  Buttons+macOS.swift
//  Komodio
//
//  Created by Nick Berendsen on 24/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

extension Buttons {

    /// The 'play' button
    struct Play: View {
        var item: any KodiItem
        @Environment(\.openWindow) var openWindow
        var body: some View {
            Button(action: {
                let video = MediaItem(id: item.id, resume: false, item: item)
                openWindow(value: video)
            }, label: {
                Text("Play")
            })
        }
    }

    /// The 'resume' button
    struct Resume: View {
        var item: any KodiItem
        @Environment(\.openWindow) var openWindow
        var body: some View {
            Button(action: {
                let video = MediaItem(id: item.id, resume: true, item: item)
                openWindow(value: video)
            }, label: {
                Text("Resume")
            })
        }
    }

    /// The 'played state' button
    struct PlayedState: View {
        var item: any KodiItem
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
            })
        }
    }
}
