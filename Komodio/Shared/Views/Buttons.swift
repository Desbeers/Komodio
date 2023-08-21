//
//  Buttons.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI


// MARK: Buttons

/// Collection of SwiftUI Buttons (shared)
///
/// - The ``Play`` and ``Resume`` buttons between macOS and tvOS are very different and in its own file
enum Buttons {
    // Just a namespace here
}

extension Buttons {

    // MARK: Player

    /// The 'play',  'resume' and optional 'played state' buttons
    struct Player: View {
        /// The `KodiItem`
        var item: any KodiItem
        /// Bool to show the `state` button or not
        var showState: Bool = true
        /// Bool to fade the `state` button on focus or not
        var fadeStateButton: Bool = false
        /// The focus state of the player buttons
        @FocusState var isFocused: Bool

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            HStack {
                switch KomodioPlayerView.canPlay(video: item) {
                case true:
                    Buttons.Play(item: item)
                    if item.resume.position != 0 {
                        Buttons.Resume(item: item)
                    }
                case false:
                    KomodioPlayerView.CantPlay(video: item)
                }
                if showState && (StaticSetting.platform != .tvOS ? true : fadeStateButton ? isFocused : true) {
                    Buttons.PlayedState(item: item)
                }
            }
            .focused($isFocused)
            .labelStyle(.playLabel)
            .buttonStyle(.playButton)
            .animation(.default, value: isFocused)
        }
    }

    // MARK: Played State

    /// The 'played state' button
    struct PlayedState: View {
        /// The `KodiItem` to set
        let item: any KodiItem

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                Label(title: {
                    Text(
                        item.playcount == 0 ?
                        "Mark \(item.media.description) as watched" : "Mark  \(item.media.description) as new"
                    )
                }, icon: {
                    Image(systemName: item.playcount == 0 ? "eye.fill" : "eye")
                })
            })
        }
    }
}


extension Buttons {

    // MARK: Play Button

    /// The 'play' button
    struct Play: View {
        /// The `KodiItem` to play
        var item: any KodiItem
        /// Bool if the player will be presented
        @State private var isPresented = false
        /// The media item to pass to the player
        private var video: MediaItem {
            MediaItem(
                id: item.kodiID,
                title: item.title,
                media: item.media,
                resume: false
            )
        }
#if os(macOS)
        /// Open Window environment
        @Environment(\.openWindow)
        var openWindow
        /// The button action
        private var action: () {
            openWindow(value: video)
        }
#else
        /// The button action
        private var action: () {
            isPresented.toggle()
        }
#endif

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    action
                },
                label: {
                    formatButtonLabel(
                        title: "Play",
                        subtitle: item.resume.position == 0 ? nil : "From beginning",
                        icon: "play.fill")
                })
#if !os(macOS)
            .fullScreenCover(isPresented: $isPresented) {
                KomodioPlayerView(media: video)
            }
#endif
        }
    }

    // MARK: Resume Button

    /// The 'resume' button
    struct Resume: View {
        /// The `KodiItem` to resume
        var item: any KodiItem
        /// Bool if the player will be presented
        @State private var isPresented = false
        /// Calculate the resume time
        private var resume: Int {
            Int(item.resume.total - item.resume.position)
        }
        /// The media item to pass to the player
        private var video: MediaItem {
            MediaItem(
                id: item.kodiID,
                title: item.title,
                media: item.media,
                resume: true
            )
        }
#if os(macOS)
        /// Open Window environment
        @Environment(\.openWindow) var openWindow
        /// The button action
        private var action: () {
            openWindow(value: video)
        }
#else
        /// The button action
        private var action: () {
            isPresented.toggle()
        }
#endif

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    action
                },
                label: {
                    formatButtonLabel(
                        title: "Resume",
                        subtitle: "\(Utils.secondsToTimeString(seconds: resume)) to go",
                        icon: "play.fill"
                    )
                })
#if !os(macOS)
            .fullScreenCover(isPresented: $isPresented) {
                KomodioPlayerView(media: video)
            }
#endif
        }
    }
}

extension Buttons {

    /// Format a label for a button
    /// - Parameters:
    ///   - title: The title
    ///   - subtitle: The optional subtile
    ///   - icon: Name of the SF symbol
    ///   - color: The color for the icon
    /// - Returns: A SwiftUI `Label`
    static func formatButtonLabel(
        title: String,
        subtitle: String?,
        icon: String,
        color: Color? = nil
    ) -> some View {
        /// Calculate the font size for the subtitle
        var subtitleFontSize: Double {
            switch StaticSetting.platform {
            case .macOS:
                return 10
            case .tvOS:
                return 20
            case .iPadOS:
                return 14
            }
        }
        return Label(title: {
            VStack(alignment: .leading) {
                Text(.init(title))
                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: subtitleFontSize))
                        .opacity(0.8)
                }
            }
        }, icon: {
            if let color {
                Image(systemName: icon)
                    .foregroundColor(color)
            } else {
                Image(systemName: icon)
            }
        })
    }
}

extension Buttons {

    // MARK: CollectionStyle

    /// Button for selecting the collection style
    struct CollectionStyle: View {
        /// Bool to hide this button
        /// - Note: on macOS, this button is in the toolbar and ignored in ``CollectionView``
        var hide: Bool = true
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// The body of the `View`
        var body: some View {
#if os(macOS)
            if hide {
                EmptyView()
            } else {
                content
            }
#else
            content
#endif
        }
        /// The content of the `View`
        var content: some View {
            Button(
                action: {
                    Task { @MainActor in
                        scene.collectionStyle = scene.collectionStyle == .asGrid ? .asList : .asGrid
                    }
                }, label: {
                    Label(
                        "List Style",
                        systemImage: scene.collectionStyle == .asList ? "list.bullet" : "square.grid.2x2"
                    )
                }
            )
            .labelStyle(.iconOnly)
        }
    }
}

extension Buttons {

    // MARK: CollectionSort

    /// Button, menu or picker to sort a collection
    struct CollectionSort: View {
        /// The sorting
        @Binding var sorting: SwiftlyKodiAPI.List.Sort
        /// The media
        let media: Library.Media
        /// Bool to show the Sheet (tvOS)
        @State private var showSheet: Bool = false
        /// The body of the `View`
        var body: some View {
#if os(macOS)
            KodiListSort.SortPickerView(sorting: $sorting, media: media)
#endif
#if os(iOS) || os(visionOS)
            Menu(
                content: {
                    KodiListSort.SortPickerView(sorting: $sorting, media: media)
                },
                label: {
                    Label(
                        title: {
                            Text("\(sorting.method.shortLabel)")
                        },
                        icon: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    )
                }
            )
            .labelStyle(.titleAndIcon)
#endif
#if os(tvOS)
            Button(
                action: {
                    showSheet.toggle()
                },
                label: {
                    Label(
                        title: {
                            Text("\(sorting.method.shortLabel)")
                        },
                        icon: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    )
                }
            )
            .sheet(isPresented: $showSheet) {
                KodiListSort.SortPickerView(sorting: $sorting, media: media)
            }
#endif
        }
    }
}
