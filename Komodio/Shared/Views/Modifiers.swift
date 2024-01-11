//
//  Modifiers.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Modifiers

/// Collection of SwiftUI `View` Modifiers (shared)
enum Modifiers {
    // Just a namespace here...
}

extension Modifiers {

    // MARK: Watch Status Modifier

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
                    .font(StaticSetting.platform == .macOS ? .title3 : .body)
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

extension Modifiers {

    // MARK: KodiItem details font modifier

    /// A `ViewModifier` to set de font style for details of a `KodiItem`
    struct DetailsFontStyle: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .font(.system(size: 16))
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

extension Modifiers {

    // MARK: Set Background modifier

    /// A `ViewModifier` to set the fanart background
    struct SetBackground: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
                .background(
                    ZStack {
                        Color.blend
                        Image(.background)
                            .resizable()
                            .aspectRatio(1.778, contentMode: .fill)
                            .opacity(0.1)
                            .blendMode(.luminosity)
                    }
                        .ignoresSafeArea()
                        .scaledToFill()
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

    // MARK: Fanart Style modifier

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
                            .font(StaticSetting.platform == .macOS ? .headline : .subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(.regularMaterial)
                    }
                }
                .cornerRadius(StaticSetting.cornerRadius)
        }
    }
}

extension View {

    /// A `ViewModifier` to style the fanart of a `KodiItem`
    func fanartStyle(item: any KodiItem, overlay: String? = nil) -> some View {
        modifier(Modifiers.FanartStyle(item: item, overlay: overlay))
    }
}

extension Modifiers {

    // MARK: Cell button modifier

    /// A `ViewModifier` to style the button of a `KodiItem`
    struct CellButton: ViewModifier {
        /// The SceneState model
        @Environment(SceneState.self) private var scene
        /// The `KodiItem`
        let item: any KodiItem
        /// The `KodiCell`
        let cell: KodiCell
        /// The style of the cell
        let style: ScrollCollectionStyle
        /// The modifier
        func body(content: Content) -> some View {
            content

#if os(macOS)
                .buttonStyle(.cellButton(item: item, selected: scene.detailSelection == cell.details, style: style))
                .padding(.horizontal, style == .asList ? StaticSetting.cellPadding : 0)
                .padding(.bottom, StaticSetting.cellPadding)
#endif

#if os(tvOS)
                .tvOSButton(style: style)
                .padding(.top, style == .asPlain ? StaticSetting.cellPadding : 0)
                .padding(.bottom, StaticSetting.cellPadding)
                .padding(.horizontal, style == .asList ? StaticSetting.cellPadding : 0)
#endif

#if os(iOS)
                .buttonStyle(.cellButton(item: item, selected: scene.detailSelection == cell.details, style: style))
                .padding(.bottom, StaticSetting.cellPadding)
#endif

#if os(visionOS)
                .buttonStyle(.cellButton(item: item, selected: scene.detailSelection == cell.details, style: style))
                .padding(.bottom, StaticSetting.cellPadding)
#endif
        }
    }
}

extension View {

    /// A `ViewModifier` to style the button of a `KodiItem`
    func cellButton(item: any KodiItem, cell: KodiCell, style: ScrollCollectionStyle) -> some View {
        modifier(Modifiers.CellButton(item: item, cell: cell, style: style))
    }
}

#if os(tvOS)

extension View {

    @ViewBuilder func tvOSButton(style: ScrollCollectionStyle) -> some View {
        if style == .asList {
            self.buttonStyle(.card)
        } else {
            self.buttonStyle(.borderless)
        }
    }
}

#endif

extension Modifiers {

    // MARK: Full Screen modifier

    /// A `ViewModifier` to set the safe area in full screen (macOS)
    struct FullScreenSafeArea: ViewModifier {
#if os(macOS)
        /// The SceneState model
        @Environment(SceneState.self) private var appDelegate
#endif
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .ignoresSafeArea(.all, edges: appDelegate.fullScreen ? .bottom : .all)
#else
                .ignoresSafeArea()
#endif
        }
    }
}

extension View {

    /// A `ViewModifier` to set the safe area in full screen (macOS)
    func fullScreenSafeArea() -> some View {
        modifier(Modifiers.FullScreenSafeArea())
    }
}

#if canImport(UIKit)

extension Modifiers {

    // MARK: Rounded Corners

    struct RoundedCorner: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(Modifiers.RoundedCorner(radius: radius, corners: corners) )
    }
}

#endif
