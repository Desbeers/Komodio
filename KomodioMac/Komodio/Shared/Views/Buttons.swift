//
//  Buttons.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Buttons
enum Buttons {
    // Just a NameSpace here
}

extension Buttons {

    /// The 'play',  'resume' and 'watch status' buttons
    struct Player: View {
        var item: any KodiItem
        var body: some View {
            HStack {
                Buttons.Play(item: item)
                if item.resume.position != 0 {
                    Buttons.Resume(item: item)
                }
                Buttons.PlayedState(item: item)
            }
            .padding(.bottom)
        }
    }

}
