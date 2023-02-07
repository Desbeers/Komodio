//
//  Buttons.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Buttons (shared)
///
/// - The ``Play`` and ``Resume`` buttons between macOS and tvOS are very different and in its on file
enum Buttons {
    // Just a namespace here
}

extension Buttons {

    /// The 'play',  'resume' and optional 'played state' buttons
    struct Player: View {
        /// The `KodiItem`
        var item: any KodiItem
        /// Bool to show the `state` button or not
        var showState: Bool = true
        /// Bool to fade the `state` button on focus or not
        var fadeStateButton: Bool = false
        /// The focus state of the player buttons
        @FocusState var isFocused: Bool

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
                switch KomodioPlayerView.canPlay(video: item) {
                case true:
                    Buttons.Play(item: item)
                    if item.resume.position != 0 {
                        Buttons.Resume(item: item)
                    }
                    if showState && (KomodioApp.platform == .macOS ? true : fadeStateButton ? isFocused : true) {
                        Buttons.PlayedState(item: item)
                    }
                case false:
                    KomodioPlayerView.CantPlay(video: item)
                }
            }
            .focused($isFocused)
            .labelStyle(.playLabel)
            .buttonStyle(.playButton)
            .animation(.default, value: isFocused)
        }
    }

    /// The 'played state' button
    struct PlayedState: View {
        /// The `KodiItem` to set
        let item: any KodiItem

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                Label(title: {
                    Text(item.playcount == 0 ? "Mark \(item.media.description) as watched" : "Mark  \(item.media.description) as new")
                }, icon: {
                    Image(systemName: item.playcount == 0 ? "eye.fill" : "eye")
                })
            })
        }
    }
}
