//
//  Buttons.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Buttons
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
                    if state {
                        Buttons.PlayedState(item: item)
                    }
                case false:
                    KomodioPlayerView.CantPlay(video: item)
                }
            }
            .labelStyle(Styles.PlayLabel())
            .buttonStyle(Styles.PlayButton())
        }
    }

}
