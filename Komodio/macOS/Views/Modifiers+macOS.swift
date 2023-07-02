//
//  Modifiers+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension Modifiers {

    // MARK: NavigationStack Animation

    /// A `ViewModifier` to animate the navigation stack
    struct NavigationStackAnimation: ViewModifier {
        /// The opacity
        @Binding var opacity: Double
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The modifier
        func body(content: Content) -> some View {
            content
                .offset(x: opacity == 0 ? -KomodioApp.detailWidth : 0, y: 0)
                .onChange(of: scene.navigationStackPath) { value in
                    switch value.count {
                    case 0:
                        opacity = 1
                    default:
                        opacity = 0
                    }
                }
        }
    }
}

extension View {

    /// A `ViewModifier` to animate the navigation stack
    func navigationStackAnimation(opacity: Binding<Double>) -> some View {
        modifier(Modifiers.NavigationStackAnimation(opacity: opacity))
    }
}
