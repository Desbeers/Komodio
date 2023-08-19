//
//  Backport.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Backport SwiftUI functions for easier multi-targeting
public struct Backport<Content> {
    /// The content of the backport
    public let content: Content
    /// Init the backport
    public init(_ content: Content) {
        self.content = content
    }
}

extension View {
    /// The base for backport
    var backport: Backport<Self> { Backport(self) }
}

extension Backport where Content: View {

    /// `focusSection` backport
    @ViewBuilder
    func focusSection() -> some View {
        content
#if os(tvOS)
            .focusSection()
#endif
    }
}

extension Backport where Content: View {

    /// `focusable` backport
    @ViewBuilder
    func focusable() -> some View {
        content
#if !os(iOS)
            .focusable()
#endif
    }
}

extension Backport where Content: View {

    /// `navigationSubtitle` backport
    @ViewBuilder
    func navigationSubtitle(_ text: String) -> some View {
        content
#if os(macOS)
            .navigationSubtitle(text)
#endif
    }
}
