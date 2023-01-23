//
//  Styles.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI styles for `buttons` and `labels` (shared)
enum Styles {
    // Just a Namespace
}

// MARK: Button styles

extension Styles {

    /// SwiftUI Button style for a Play Button
    struct PlayButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {

#if os(macOS)
            configuration.label
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.default, value: configuration.isPressed)
#endif

#if os(tvOS)
            configuration.label
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.default, value: configuration.isPressed)
#endif

        }
    }
}

// MARK: Label styles

extension Styles {

    /// SwiftUI Label style for a Play Button
    struct PlayLabel: LabelStyle {
        /// Bool if the label is focussed
        @Environment(\.isFocused) private var focused: Bool
        func makeBody(configuration: Configuration) -> some View {

#if os(macOS)
            HStack {
                configuration.icon
                    .opacity(0.6)
                configuration.title
            }
            .padding()
            .frame(height: 50)
            .foregroundColor(.black)
            .background(.white.gradient)
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

    /// SwiftUI Label style for a media item detail label
    struct DetailLabel: LabelStyle {
        /// Bool if the label is focussed
        @Environment(\.isFocused) var focused: Bool
        func makeBody(configuration: Configuration) -> some View {

#if os(macOS)
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
            .foregroundColor(.white)
#endif

        }
    }
}
