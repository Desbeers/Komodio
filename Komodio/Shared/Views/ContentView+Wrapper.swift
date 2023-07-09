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
        /// The header of the `View`
        @ViewBuilder var header: () -> Header
        /// The content of the `View`
        @ViewBuilder var content: () -> Content
        /// The inside padding
        private var insidePadding: Double {
            switch KomodioApp.platform {
            case .macOS:
                return 40
            case .tvOS:
                return 40
            case .iPadOS:
                return 20
            }
        }

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
            .padding([.top, .horizontal])
#if os(tvOS)
            .padding(.leading)
            /// Extra padding for the sidebar
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
                .padding(.horizontal, insidePadding)
            /// No scrollbar means no vertical padding; the inside content might be a list that wants to scroll from top to bottom
                .padding(.vertical, scroll ? insidePadding : 0)
        }
    }
}
