//
//  Buttons.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import SwiftUI
import SwiftlyKodiAPI

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
            }
        }
    }
    
    struct Play: View {
        var item: any KodiItem
        @Environment(\.openWindow) var openWindow
        var body: some View {
            Button(action: {
                let video = VideoItem(id: item.id, resume: false, video: item)
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
                let video = VideoItem(id: item.id, resume: true, video: item)
                openWindow(value: video)
            }, label: {
                Text("Resume")
            })
        }
    }
}
