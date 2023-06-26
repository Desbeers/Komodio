//
//  ContentView+Wrapper.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ContentView {

    /// SwiftUI View to wrap the ``ContentView``
    struct Wrapper<Header: View, Content: View>: View {
        /// Wrap the view in a `ScollView` or not
        var scroll: Bool = true
        /// The header of the View
        @ViewBuilder var header: () -> Header
        /// The content of the View
        @ViewBuilder var content: () -> Content

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack(spacing: 0) {
                if scroll {
                    ScrollView {
                        inside
                    }
                } else {
                    inside
                }
            }
            .padding(.leading)
#if os(tvOS)
            .padding(.leading, KomodioApp.sidebarCollapsedWidth)
            .ignoresSafeArea()
#endif
        }
        /// The inside of the View
        @ViewBuilder var inside: some View {
            header()
                .frame(maxWidth: .infinity)
                .backport.focusSection()
            content()
                .padding(40)
        }
    }
}
