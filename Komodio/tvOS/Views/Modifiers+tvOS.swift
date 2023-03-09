//
//  Modifiers+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: Safe Areas Modifier

extension Modifiers {

    /// A `ViewModifier` to reserve the leading of the `Safe Areas` for the ``SidebarView``
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

    //// A `ViewModifier` to reserve the leading of the `Safe Areas` for the ``SidebarView``
    func setSafeAreas() -> some View {
        modifier(Modifiers.SafeAreas())
    }
}
