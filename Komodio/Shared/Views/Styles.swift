//
//  Styles.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Styles

/// SwiftUI styles for `buttons` and `labels` (shared)
enum Styles {
    // Just a Namespace
}

// MARK: Button styles

extension Styles {

    // MARK: List Button

    /// SwiftUI Button style for a list Button
    struct ListButton: ButtonStyle {
        /// Bool if the item is selected
        let selected: Bool
        /// The focus state
        @Environment(\.isFocused) var focused: Bool

        func makeBody(configuration: Configuration) -> some View {
#if os(macOS)
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .foregroundColor(selected ? Color.white : Color.primary)
                .background(selected ? Color.accentColor : Color.clear)
                .cornerRadius(6)
#endif

#if os(tvOS)
            configuration.label
                .padding()
                .foregroundColor(selected ? .white : .primary)
                .background(selected ? Color.black : Color("AccentColor"))
                .cornerRadius(16)
                .shadow(radius: 3, x: 0, y: 2)
                .scaleEffect(focused ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: focused)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.ListButton {
    /// Button style for a 'play' button
    static func listButton(selected: Bool) -> Styles.ListButton { .init(selected: selected) }
}

extension Styles {

    // MARK: Play Button

    /// SwiftUI Button style for a Play Button
    struct PlayButton: ButtonStyle {
        /// Enabled or not
        @Environment(\.isEnabled) var isEnabled

        func makeBody(configuration: Configuration) -> some View {
#if os(macOS)
            configuration.label
                .cornerRadius(6)
                .shadow(radius: 1)
                .opacity(configuration.isPressed ? 0.8 : isEnabled ? 1 : 0.3)
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

extension ButtonStyle where Self == Styles.PlayButton {
    /// Button style for a 'play' button
    static var playButton: Styles.PlayButton { .init() }
}

// MARK: Label styles

extension Styles {

    // MARK: Play Label

    /// SwiftUI Label style for a Play Button
    struct PlayLabel: LabelStyle {
        /// Current color scheme
        @Environment(\.colorScheme) var colorScheme
        /// Bool if the label is focussed
        @Environment(\.isFocused) private var focused: Bool
        func makeBody(configuration: Configuration) -> some View {
#if os(macOS)
            HStack {
                configuration.icon
                configuration.title
            }
            /// Make sure two lines will fit
            .frame(height: 25)
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

    // MARK: Detail Label

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
#endif
        }
    }

    // MARK: Header Label

    /// SwiftUI Label style for a HeaderView Button (tvOS)
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

extension LabelStyle where Self == Styles.PlayLabel {
    /// SwiftUI Label style for a Play Button
    static var playLabel: Styles.PlayLabel { .init() }
}

extension LabelStyle where Self == Styles.DetailLabel {
    /// SwiftUI Label style for a DetailView Label
    static var detailLabel: Styles.DetailLabel { .init() }
}

extension LabelStyle where Self == Styles.HeaderLabel {
    /// SwiftUI Label style for a HeaderView Button (tvOS)
    static var headerLabel: Styles.HeaderLabel { .init() }
}
