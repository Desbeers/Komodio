//
//  Buttons.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Buttons (shared)
enum Buttons {
    // Just a namespace here
}

extension Buttons {

    /// The 'play',  'resume' and 'watch status' buttons
    struct Player: View {
        /// The `KodiItem`
        var item: any KodiItem
        /// Bool to show the `state` button or not
        var state: Bool = true
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
                    if state && (KomodioApp.platform == .macOS ? true : isFocused) {
                        Buttons.PlayedState(item: item)
                    }
                case false:
                    KomodioPlayerView.CantPlay(video: item)
                }
            }
            .focused($isFocused)
            .labelStyle(Styles.PlayLabel())
            .buttonStyle(Styles.PlayButton())
            .animation(.default, value: isFocused)
        }
    }

    /// A Button to toggle the watched state of a movie set
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct MovieSetToggle: View {
        /// The set we want to toggle
        let set: Video.Details.MovieSet
        /// The body of this View
        var body: some View {
            VStack {
                Button(action: {
                    Task {
                        await set.togglePlayedState()
                    }
                }, label: {
                    Label(title: {
                        Text(set.playcount == 0 ? "Mark all movies as watched" : "Mark all movies as new")
                    }, icon: {
                        Image(systemName: set.playcount == 0 ? "eye.fill" : "eye")
                    })
                })
                .labelStyle(Styles.PlayLabel())
            }
        }
    }
}
