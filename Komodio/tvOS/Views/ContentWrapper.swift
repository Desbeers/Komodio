//
//  ContentWrapper.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI View to wrap the ``ContentView`` (tvOS)
struct ContentWrapper<Header: View, Content: View>: View {
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
        .padding(.leading, KomodioApp.sidebarCollapsedWidth)
        .ignoresSafeArea()
    }
    /// The inside of the View
    @ViewBuilder var inside: some View {
        header()
            .frame(maxWidth: .infinity)
            .focusSection()
        content()
            .padding(40)
    }
}
