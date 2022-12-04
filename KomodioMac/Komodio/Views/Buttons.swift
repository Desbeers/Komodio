//
//  Buttons.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Buttons
enum Buttons {}

extension Buttons {
    
    struct Player: View {
        var item: any KodiItem
        var body: some View {
            HStack {
                Buttons.Play(item: item)
                if item.resume.position != 0 {
                    Buttons.Resume(item: item)
                }
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
}
