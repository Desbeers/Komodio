//
//  ButtonStyles.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

extension Styles {

    // MARK: Card Buttom Backport

    /// Backport for ButtonStyle `card`; only native available on tvOS
    struct CardBackport: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
#if os(tvOS)
            configuration.label
                .buttonStyle(.card)
#else
            configuration.label
                .cornerRadius(KomodioApp.cornerRadius)
                .shadow(radius: KomodioApp.cornerRadius, x: KomodioApp.cornerRadius, y: KomodioApp.cornerRadius)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.CardBackport {
    /// Backport for ButtonStyle `card`; only native available on tvOS
    static var cardBackport: Styles.CardBackport { .init() }
}

extension Styles {

    // MARK: KodiItem Button

    /// SwiftUI Button style for a KodiItem Button
    struct KodiItemButton: ButtonStyle {
        /// The `KodiItem`
        let kodiItem: any KodiItem
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The focus state
        @Environment(\.isFocused) var focused: Bool
        /// Avoid error in the `View extension` when Strict Concurrency Checking is set to 'complete'
        nonisolated init(kodiItem: any KodiItem) {
            self.kodiItem = kodiItem
        }

        func makeBody(configuration: Configuration) -> some View {
            let selected = kodiItem.id == scene.details.item.kodiItem?.id
#if os(macOS)
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .foregroundColor(selected ? Color.white : Color.primary)
                .background(selected ? Color.accentColor : Color.clear)
                .cornerRadius(6)
#endif

#if os(tvOS) || os(iOS)
            configuration.label
                .foregroundColor(selected ? .white : .primary)
                .background(selected ? Color.black : Color("AccentColor"))
                .cornerRadius(KomodioApp.cornerRadius)
                .shadow(radius: 3, x: 0, y: 2)
                .scaleEffect(focused ? 1.1 : 1)
                .scaleEffect(selected ? 1.1 : 1)
                .animation(.easeOut(duration: 0.2), value: focused)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.KodiItemButton {
    /// Button style for a 'KodiItem' button
    static func kodiItemButton(kodiItem: any KodiItem) -> Styles.KodiItemButton { .init(kodiItem: kodiItem) }
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
                .cornerRadius(KomodioApp.cornerRadius)
                .shadow(radius: 1)
                .opacity(configuration.isPressed ? 0.8 : isEnabled ? 1 : 0.3)
                .animation(.default, value: configuration.isPressed)
                .labelStyle(.playLabel)
#endif

#if os(tvOS)
            configuration.label
                .cornerRadius(KomodioApp.cornerRadius)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.default, value: configuration.isPressed)
                .labelStyle(.playLabel)
#endif

#if os(iOS)
            configuration.label
                .cornerRadius(KomodioApp.cornerRadius)
                .shadow(radius: 1)
                .opacity(configuration.isPressed ? 0.8 : isEnabled ? 1 : 0.3)
                .animation(.default, value: configuration.isPressed)
                .labelStyle(.playLabel)
#endif
        }
    }
}

extension ButtonStyle where Self == Styles.PlayButton {
    /// Button style for a 'play' button
    static var playButton: Styles.PlayButton { .init() }
}
