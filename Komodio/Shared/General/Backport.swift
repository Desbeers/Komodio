//
//  File.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

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
    @ViewBuilder func focusSection() -> some View {
#if !os(tvOS)
        content
#else
        content
            .focusSection()
#endif
    }
}

extension Backport where Content: View {
    /// `focusable` backport
    @ViewBuilder func focusable() -> some View {
#if os(iOS)
        content
#else
        content
            .focusable()
#endif
    }
}

extension Backport where Content: View {
    /// `navigationSubtitle` backport
    @ViewBuilder func navigationSubtitle(_ text: String) -> some View {
#if os(iOS) || os(tvOS)
        content
#else
        content
            .navigationSubtitle(text)
#endif
    }
}

extension Backport where Content: View {

    /// Add ButtonStyle `card` to a View
    ///
    /// - Note: Native for tvOS only
    /// - Returns: A View with the `ButtonStyle` attached
    @ViewBuilder func cardButton() -> some View {
#if os(tvOS)
        content
            .buttonStyle(.card)
#else
        content
            .buttonStyle(.cardBackport)
#endif
    }
}
