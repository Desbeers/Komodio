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
                                PartsView.GradientOverlay()
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

// MARK: Details wrapper

extension Modifiers {

    /// A `ViewModifier` to wrap the ``DetailView`` for the specific platfom
    struct DetailsWrapper: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {

#if os(macOS)
            /// Wrap the content in a `ScrollView` and give it inside padding
            ScrollView {
                content
                    .padding(40)
            }
#endif

#if os(tvOS)
            /// Just show the content at full height; tvOS does not scroll
            content
                .padding(.vertical, 40)
                .frame(height: UIScreen.main.bounds.height, alignment: .top)
#endif

        }
    }
}

extension View {

    /// A `ViewModifier` to wrap the ``DetailView`` for the specific platfom
    func detailsWrapper() -> some View {
        modifier(Modifiers.DetailsWrapper())
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

// MARK: Fanart modifier

extension Modifiers {

    /// A `ViewModifier` to style the fanart of a `MediaItem`
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
                .cornerRadius(10)
#if os(macOS)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
#endif
        }
    }
}

extension View {

    /// A `ViewModifier` to style the fanart of a `MediaItem`
    func fanartStyle(item: any KodiItem, overlay: String? = nil) -> some View {
        modifier(Modifiers.FanartStyle(item: item, overlay: overlay))
    }
}
