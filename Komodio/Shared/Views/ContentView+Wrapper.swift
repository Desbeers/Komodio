//
//  ContentView+Wrapper.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension ContentView {

    /// SwiftUI `View` to wrap the ``ContentView``
    struct Wrapper<Header: View, Content: View, Buttons: View>: View {
        /// Init the `View`
        init(@ViewBuilder header: () -> Header, @ViewBuilder content: () -> Content, @ViewBuilder buttons: () -> Buttons) {
            self.header = header()
            self.content = content()
            self.buttons = buttons()
        }
        /// The header of the `View`
        let header: Header
        /// The content of the `View`
        let content: Content
        /// The buttons of the `View`
        let buttons: Buttons
        /// Current color scheme
        @Environment(\.colorScheme) var colorScheme

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
#if os(macOS)
            HStack {
                buttons
                    .pickerStyle(.segmented)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .horizontal])
            content
#endif

#if os(tvOS)
            VStack(spacing: 0) {
                header
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        HStack(alignment: .firstTextBaseline) {
                            buttons
                        }
                        .font(.caption)
                        .menuStyle(.button)
                        .padding(.trailing, 80)
                        .foregroundColor(colorScheme == .light ? .gray : .black)
                    }
                    .focusSection()
                content
                    .padding(.horizontal, StaticSetting.cornerRadius)
                    .focusSection()
            }
            .padding()
            .padding(.leading)
            /// Extra padding for the sidebar
            .padding(.leading, StaticSetting.sidebarCollapsedWidth)
            .ignoresSafeArea()
#endif

#if os(iOS) || os(visionOS)
            VStack(spacing: 0) {
                header
                    .frame(maxWidth: .infinity)
                content()
                    .padding(.horizontal, StaticSetting.cornerRadius)
            }
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
            .toolbar {
                buttons
            }
#endif
        }
    }
}
