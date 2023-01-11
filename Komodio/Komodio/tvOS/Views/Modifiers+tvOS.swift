//
//  Modifiers+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: Safe Areas Modifier

extension Modifiers {

    /// A `ViewModifier` to fill the leading the `Safe Areas` with the ``SidebarView``
    struct SafeAreas: ViewModifier {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The Presentation mode
        @Environment(\.presentationMode) var presentationMode
        /// The modifier
        func body(content: Content) -> some View {
            content
                .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
                    Color.clear.frame(width: KomodioApp.sidebarCollapsedWidth)
                }
                .onExitCommand {
                    scene.background = nil
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/SafeAreas``
    func setSafeAreas() -> some View {
        modifier(Modifiers.SafeAreas())
    }
}
