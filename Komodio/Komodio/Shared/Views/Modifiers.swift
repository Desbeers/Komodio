//
//  Modifiers.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI View Modifiers (shared)
enum Modifiers {
    // Just a namespace here...
}

// MARK: Watch Status Modifier

extension Modifiers {

    /// A `ViewModifier` to show a star for unwatched items
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct WatchStatus: ViewModifier {
        /// The Kodi  item
        let item: any KodiItem
        /// The modifier
        func body(content: Content) -> some View {
            content
                .overlay(alignment: .topTrailing) {
                    Image(systemName: item.media == .movieSet ? "circle.grid.cross.fill" : item.resume.position == 0 ? "star.fill" : "circle.lefthalf.filled")
                        .font(KomodioApp.platform == .macOS ? .title3 : .body)
                        .foregroundColor(.yellow)
                        .opacity(item.playcount == 0 || item.resume.position != 0 ? 1 : 0)
                }
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/WatchStatus``
    func watchStatus(of item: any KodiItem) -> some View {
        modifier(Modifiers.WatchStatus(item: item))
    }
}

// MARK: Background Modifier

extension Modifiers {

    /// A `ViewModifier` to set a backgound
    ///
    /// On macOS, it will be set as `background` for the `View`
    /// On tvOS, it will be set to the `SceneState/background`
    struct Background: ViewModifier {
        /// The `KodiItem`
        let item: any KodiItem
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .background(
                    ZStack {
                        Color(nsColor: .controlBackgroundColor)
                        KodiArt.Fanart(item: item)
                            .scaledToFill()
                            .opacity(0.2)
                            .overlay {
                                Parts.GradientOverlay()
                                    .opacity(0.3)
                            }
                    }
                )
#endif
#if os(tvOS)
                .task {
                    scene.background = item
                }
#endif
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/Background``
    func background(item: any KodiItem) -> some View {
        modifier(Modifiers.Background(item: item))
    }
}

// MARK: Item details font modifier

extension Modifiers {

    /// A `ViewModifier` to set de font style for details of a `MediaItem`
    struct DetailsFontStyle: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
                .font(.system(size: 14))
                .lineSpacing(6)
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/DetailsFontStyle``
    func detailsFontStyle() -> some View {
        modifier(Modifiers.DetailsFontStyle())
    }
}
