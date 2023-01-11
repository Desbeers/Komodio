//
//  Buttons+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension Buttons {

    /// The 'play' button
    struct Play: View {
        /// The `KodiItem` to play
        var item: any KodiItem
        /// Open Window environment
        @Environment(\.openWindow) var openWindow

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                let video = MediaItem(id: item.id, resume: false, item: item)
                openWindow(value: video)
            }, label: {
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("Play")
                        if item.resume.position != 0 {
                            Text("From beginning")
                                .font(.caption)
                        }
                    }
                }, icon: {
                    Image(systemName: "play.fill")
                })
            })
        }
    }

    /// The 'resume' button
    struct Resume: View {
        /// The `KodiItem` to resume
        var item: any KodiItem
        /// Open Window environment
        @Environment(\.openWindow) var openWindow

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                let video = MediaItem(id: item.id, resume: true, item: item)
                openWindow(value: video)
            }, label: {
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("Resume")
                        Text("\(Parts.secondsToTime(seconds: Int(item.resume.total - item.resume.position))) to go")
                            .font(.caption)
                    }
                }, icon: {
                    Image(systemName: "play.fill")
                })
            })
        }
    }

    /// The 'played state' button
    struct PlayedState: View {
        /// The `KodiItem` to set
        var item: any KodiItem

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                Label(title: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                }, icon: {
                    Image(systemName: item.playcount == 0 ? "eye.fill" : "eye")
                })
            })
        }
    }
}
