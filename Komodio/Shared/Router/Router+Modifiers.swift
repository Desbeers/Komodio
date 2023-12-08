//
//  Router+Modifiers.swift
//  Komodio
//
//  Created by Nick Berendsen on 24/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

extension Router {

    /// A `ViewModifier` to add platform specific stuff to a View
    struct AppendPlatformStuff: ViewModifier {
        /// The current Router item
        let router: Router
        /// The SceneState model
        @Environment(SceneState.self) private var scene
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .navigationSubtitle(router.item.title)
#elseif os(tvOS)
                .setSiriExit()
#elseif os(iOS)
                .setBackground()
#endif
        }
    }
}

extension View {

    /// Shortcut to the ``Router/AppendPlatformStuff``
    func appendPlatformStuff(router: Router) -> some View {
        modifier(Router.AppendPlatformStuff(router: router))
    }
}
