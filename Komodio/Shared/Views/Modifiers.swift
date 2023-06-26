//
//  Modifiers.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Modifiers

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
                    Image(
                        systemName: item.media == .movieSet ?
                        "circle.grid.cross.fill" : item.resume.position == 0 ? "star.fill" : "circle.lefthalf.filled"
                    )
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

// MARK: KodiItem details font modifier

extension Modifiers {

    /// A `ViewModifier` to set de font style for details of a `KodiItem`
    struct DetailsFontStyle: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .font(.system(size: 14))
                .lineSpacing(6)
#endif
        }
    }
}

extension View {

    /// A `ViewModifier` to set the font style for details of a `KodiItem`
    func detailsFontStyle() -> some View {
        modifier(Modifiers.DetailsFontStyle())
    }
}

// MARK: Fanart modifiers

extension Modifiers {

    /// A `ViewModifier` to set the fanart background
    struct SetBackground: ViewModifier {
        /// Avoid error in the `View extension`
        nonisolated init() {}
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The modifier
        func body(content: Content) -> some View {
            content
                .background(
                    ZStack {
                        Color("BlendColor")
                        if let background = scene.selectedKodiItem, !background.fanart.isEmpty {
                            KodiArt.Fanart(item: background)
                                .grayscale(1)
                                .opacity(0.2)
                                .scaledToFill()
                        } else {
                            Image("Background")
                                .resizable()
                                .opacity(0.2)
                                .scaledToFill()
                        }
                    }
                    #if os(iOS)
                        .ignoresSafeArea(.all, edges: .bottom)
                    #else
                        .ignoresSafeArea()
                    #endif
                        .transition(.opacity)
                        .animation(.default, value: scene.selectedKodiItem?.id)
                )
        }
    }
}

extension View {

    /// A `ViewModifier` to set the fanart background
    func setBackground() -> some View {
        modifier(Modifiers.SetBackground())
    }
}

extension Modifiers {

    /// A `ViewModifier` to style the fanart of a `KodiItem`
    struct FanartStyle: ViewModifier {
        /// The `KodiItem`
        let item: any KodiItem
        /// The optional overlay
        var overlay: String?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .aspectRatio(contentMode: .fit)
                .watchStatus(of: item)
                .overlay(alignment: .bottom) {
                    if let overlay {
                        Text(overlay)
                            .font(KomodioApp.platform == .macOS ? .headline : .subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(.regularMaterial)
                    }
                }
                .cornerRadius(KomodioApp.cornerRadius)
        }
    }
}

extension View {

    /// A `ViewModifier` to style the fanart of a `MediaItem`
    func fanartStyle(item: any KodiItem, overlay: String? = nil) -> some View {
        modifier(Modifiers.FanartStyle(item: item, overlay: overlay))
    }
}
