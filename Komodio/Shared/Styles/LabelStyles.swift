//
//  LabelStyles.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/06/2023.
//

import SwiftUI

extension Styles {

    // MARK: Play Label

    /// SwiftUI Label style for a Play Button
    struct PlayLabel: LabelStyle {
        /// Current color scheme
        @Environment(\.colorScheme) var colorScheme
        /// Bool if the label is focussed
        @Environment(\.isFocused) private var focused: Bool
        func makeBody(configuration: Configuration) -> some View {
#if os(macOS) || os(iOS)
            HStack {
                configuration.icon
                configuration.title
            }
            /// Make sure two lines will fit
            .frame(height: KomodioApp.platform == .macOS ? 25 : 40)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .foregroundColor(.primary)
            .background(colorScheme == .light ? Color.white.gradient.opacity(1) : Color.gray.gradient.opacity(0.6))
#endif

#if os(tvOS)
            HStack(spacing: 0) {
                configuration.icon
                    .padding(.trailing)
                configuration.title
            }
            .padding(30)
            .foregroundColor(.black)
            .background(.white.gradient)
            .opacity(focused ? 1 : 0.6)
            .frame(height: 100)
#endif
        }
    }
}

extension LabelStyle where Self == Styles.PlayLabel {
    /// SwiftUI Label style for a Play Button
    static var playLabel: Styles.PlayLabel { .init() }
}

extension Styles {

    // MARK: Detail Label

    /// SwiftUI Label style for a media item detail label
    struct DetailLabel: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
#if os(macOS) || os(iOS)
            HStack(alignment: .top) {
                configuration.icon
                    .foregroundColor(.secondary)
                configuration.title
            }
            .padding(.bottom)
#endif

#if os(tvOS)
            HStack(spacing: 0) {
                configuration.icon
                    .padding(.trailing)
                configuration.title
            }
            .font(.caption)
            .padding(.bottom)
#endif
        }
    }
}

extension LabelStyle where Self == Styles.DetailLabel {
    /// SwiftUI Label style for a DetailView Label
    static var detailLabel: Styles.DetailLabel { .init() }
}

extension Styles {

    // MARK: Header Label

    /// SwiftUI Label style for a button in the header (tvOS)
    struct HeaderLabel: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 0) {
                configuration.icon
                    .padding(.trailing)
                configuration.title
            }
            .font(.system(size: 20))
            .padding()
        }
    }
}

extension LabelStyle where Self == Styles.HeaderLabel {
    /// SwiftUI Label style for a HeaderView Button (tvOS)
    static var headerLabel: Styles.HeaderLabel { .init() }
}
