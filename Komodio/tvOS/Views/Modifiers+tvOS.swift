//
//  Modifiers+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension Modifiers {

    // MARK: Siri Exit Modifier

    /// A `ViewModifier` to control the Siri Exit button
    struct SiriExit: ViewModifier {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The modifier
        func body(content: Content) -> some View {
            content
                .animation(.default, value: scene.navigationStackPath)
                .onExitCommand {
                    scene.selectedKodiItem = nil
                    if scene.navigationStackPath.isEmpty {
                        scene.toggleSidebar.toggle()
                    } else {
                        scene.navigationStackPath.removeLast()
                    }
                }
        }
    }
}

extension View {

    /// A `ViewModifier` to control the Siri Exit button
    func setSiriExit() -> some View {
        modifier(Modifiers.SiriExit())
    }
}
