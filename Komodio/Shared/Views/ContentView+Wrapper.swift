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
        /// The header of the `View`
        @ViewBuilder var header: () -> Header
        /// The content of the `View`
        @ViewBuilder var content: () -> Content
        /// The buttons of the `View`
        @ViewBuilder var buttons: () -> Buttons
        /// Current color scheme
        @Environment(\.colorScheme) var colorScheme

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
#if os(macOS)
            HStack {
                buttons()
                    .padding([.top, .horizontal])
                    .pickerStyle(.segmented)
            }
            content()
#endif

#if os(tvOS)
            VStack(spacing: 0) {
                header()
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .trailing) {
                        HStack {
                            buttons()
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 80)
                        .foregroundColor(colorScheme == .light ? .gray : .black)
                        .font(.caption)
                    }
                    .focusSection()
                content()
                    .padding(.horizontal, StaticSetting.cornerRadius)
                    .focusSection()
            }
            .padding()
            .padding(.leading)
            /// Extra padding for the sidebar
            .padding(.leading, StaticSetting.sidebarCollapsedWidth)
            .ignoresSafeArea()
#endif

#if os(iOS)
            VStack(spacing: 0) {
                header()
                    .frame(maxWidth: .infinity)
                content()
                    .padding(.horizontal, StaticSetting.cornerRadius)
            }
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
            .toolbar {
                buttons()
            }
#endif
        }
    }
}
