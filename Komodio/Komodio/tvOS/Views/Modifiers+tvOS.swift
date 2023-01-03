//
//  Modifiers+tvOS.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 24/12/2022.
//

import SwiftUI

// MARK: Safe Areas Modifier

extension Modifiers {

    /// A `ViewModifier` to fill the leading the `Safe Areas` with the ``SidebarView``
    struct SafeAreas: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
                .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
                    Color.clear.frame(width: KomodioApp.sidebarCollapsedWidth)
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
