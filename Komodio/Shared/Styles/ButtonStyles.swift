//
//  ButtonStyles.swift
//  Komodio
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension Styles {

    // MARK: Cell Button

    /// SwiftUI Button style for a cell Button
    struct CellButton: ButtonStyle {
        /// The `KodiItem`
        let item: any KodiItem
        /// Bool if the item is selected
        let selected: Bool
        /// The style
        let style: ScrollCollectionStyle
        /// Make the button
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(selected ? Color.white : Color.primary)
                .background(selected ? Color.accentColor : Color.secondary.opacity(0.1))
                .cornerRadius(StaticSetting.cornerRadius)
                .backport.hoverEffect()
#if os(macOS)
                .scaleEffect(selected && style == .asGrid ? 1.05 : 1)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.CellButton {
    /// Button style for a 'KodiItem' button
    static func cellButton(
        item: any KodiItem,
        selected: Bool,
        style: ScrollCollectionStyle
    ) -> Styles.CellButton {
        .init(item: item, selected: selected, style: style)
    }
}

extension Styles {

    // MARK: Play Button

    /// SwiftUI Button style for a Play Button
    struct PlayButton: ButtonStyle {
        /// Enabled or not
        @Environment(\.isEnabled) var isEnabled
        /// Make the button
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .cornerRadius(StaticSetting.cornerRadius)
                .labelStyle(.playLabel)
                .animation(.default, value: configuration.isPressed)
                .backport.hoverEffect()
#if os(macOS)
                .shadow(radius: 1)
                .opacity(configuration.isPressed ? 0.8 : isEnabled ? 1 : 0.3)
#endif

#if os(tvOS)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
#endif

#if os(iOS) || os(visionOS)
                .shadow(radius: 1)
                .opacity(configuration.isPressed ? 0.8 : isEnabled ? 1 : 0.3)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.PlayButton {
    /// Button style for a 'play' button
    static var playButton: Styles.PlayButton { .init() }
}
