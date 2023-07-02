//
//  Router+Modifiers.swift
//  Komodio
//
//  Created by Nick Berendsen on 24/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

extension Router {

    /// A `ViewModifier` to add navigation destinations
    struct NavigationDestinations: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
                .navigationDestination(for: Router.self) { router in
                    Router.DestinationView(router: router)
                        .appendStuff(router: router)
                }
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/NavigationDestinations``
    func navigationDestinations() -> some View {
        modifier(Router.NavigationDestinations())
    }
}

extension Router {

    /// A `ViewModifier` to add random stuff to a View
    struct AppendStuff: ViewModifier {
        /// The current Router item
        let router: Router
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The modifier
        func body(content: Content) -> some View {
            content
                .task {
                    scene.details = router
                }
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

    /// Shortcut to the ``Modifiers/NavigationDestinations``
    func appendStuff(router: Router) -> some View {
        modifier(Router.AppendStuff(router: router))
    }
}
