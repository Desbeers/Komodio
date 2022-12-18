//
//  Modifiers.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI View Modifiers
enum Modifiers {
    // Just a Namespace here...
}

// MARK: Content List Style Modifier

extension Modifiers {

    /// A `ViewModifier` to set the Conent List Style
    struct ContentListStyle: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
            content
#if os(macOS)
                .listStyle(.inset(alternatesRowBackgrounds: true))
#elseif os(tvOS)
                .listStyle(.automatic)
                .focusSection()
#endif
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/ContentListStyle``
    func contentListStyle() -> some View {
        modifier(Modifiers.ContentListStyle())
    }
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
                        .font(.title3)
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

// MARK: Media Item Modifier

extension Modifiers {

#if os(macOS)
    /// A `ViewModifier` to wrap a ``MoviesView/Item`` for the plaform
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct MediaViewItem: ViewModifier {
        /// The ``MediaItem``
        let item: MediaItem
        /// The currently selected ``MediaItem``
        @Binding var selectedItem: MediaItem?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .tag(item)
        }
    }
#endif

#if os(tvOS)
    /// A `ViewModifier` to wrap a ``MoviesView/Item`` for the plaform
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct MediaViewItem: ViewModifier {
        /// The ``MediaItem``
        let item: MediaItem
        /// The currently selected ``MediaItem``
        @Binding var selectedItem: MediaItem?
        /// The focus state
        @FocusState var focusState: MediaItem?
        /// Bool if focussed or not
        var focus: Bool {
            return focusState != nil
        }
        /// The modifier
        func body(content: Content) -> some View {
            content
                .saturation(focus ? 1 : 0.5)
                .scaleEffect(focus ? 1.4 : 1)
                .padding(.vertical)
                .shadow(radius: 20)
                .focusable()
            .focused($focusState, equals: item)
            .task(id: focusState) {
                if let focusState {
                    selectedItem = focusState
                }
            }
            .animation(.default, value: focus)
        }
    }
#endif
}

// MARK: TVShow Item Modifier

extension Modifiers {

#if os(macOS)
    /// A `ViewModifier` to wrap a ``TVShowsView/Item`` for the plaform
    struct TVShowsViewItem: ViewModifier {
        /// The `TVShow`
        let tvshow: Video.Details.TVShow
        /// The currently selected `TVshow`
        @Binding var selectedTVShow: Video.Details.TVShow?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .tag(tvshow)
        }
    }
#endif

#if os(tvOS)
    /// A `ViewModifier` to wrap a ``TVShowsView/Item`` for the plaform
    struct TVShowsViewItem: ViewModifier {
        /// The `TVShow`
        let tvshow: Video.Details.TVShow
        /// The currently selected `TVshow`
        @Binding var selectedTVShow: Video.Details.TVShow?
        /// The focus state
        @FocusState var focusState: Video.Details.TVShow?
        /// Bool if focussed or not
        var focus: Bool {
            return focusState != nil
        }
        /// The modifier
        func body(content: Content) -> some View {
            content
                .saturation(focus ? 1 : 0.5)
                .scaleEffect(focus ? 1.4 : 1)
                .padding(.vertical)
                .shadow(radius: 20)
                .focusable()
            .focused($focusState, equals: tvshow)
            .task(id: focusState) {
                if let focusState {
                    selectedTVShow = focusState
                }
            }
            .animation(.default, value: focus)
        }
    }
#endif
}

// MARK: Seasons Item Modifier

extension Modifiers {

#if os(macOS)
    /// A `ViewModifier` to wrap a ``SeasonsView/Item`` for the plaform
    struct SeasonsViewItem: ViewModifier {
        /// The `Season`
        let season: Int
        /// The currently selected `Season`
        @Binding var selectedSeason: Int?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .tag(season)
        }
    }
#endif

#if os(tvOS)
    /// A `ViewModifier` to wrap a ``SeasonsView/Item`` for the plaform
    struct SeasonsViewItem: ViewModifier {
        /// The `Season`
        let season: Int
        /// The currently selected `Season`
        @Binding var selectedSeason: Int?
        /// The focus state
        @FocusState var focusState: Int?
        /// Bool if focussed or not
        var focus: Bool {
            return focusState != nil
        }
        /// The modifier
        func body(content: Content) -> some View {
            content
                .saturation(focus ? 1 : 0.5)
                .scaleEffect(focus ? 1.4 : 1)
                .padding(.vertical)
                .shadow(radius: 20)
                .focusable()
            .focused($focusState, equals: season)
            .task(id: focusState) {
                if let focusState {
                    selectedSeason = focusState
                }
            }
            .animation(.default, value: focus)
        }
    }
#endif
}

// MARK: Episode Item Modifier

extension Modifiers {

#if os(macOS)
    /// A `ViewModifier` to wrap a ``EpisodeView`` for the plaform
    struct EpisodeViewItem: ViewModifier {
        /// The `Episode`
        let episode: Video.Details.Episode
        /// The currently selected `Episode`
        @Binding var selectedEpisode: Video.Details.Episode?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .tag(episode)
        }
    }
#endif

#if os(tvOS)
    /// A `ViewModifier` to wrap a ``EpisodeView`` for the plaform
    struct EpisodeViewItem: ViewModifier {
        /// The `Episode`
        let episode: Video.Details.Episode
        /// The currently selected `Episode`
        @Binding var selectedEpisode: Video.Details.Episode?
        /// The focus state
        @FocusState var focusState: Video.Details.Episode?
        /// Bool if focussed or not
        var focus: Bool {
            return focusState != nil
        }
        /// The modifier
        func body(content: Content) -> some View {
            content
                .saturation(focus ? 1 : 0.5)
                .scaleEffect(focus ? 1.4 : 1)
                .padding(.vertical)
                .shadow(radius: 20)
                .focusable()
            .focused($focusState, equals: episode)
            .task(id: focusState) {
                if let focusState {
                    selectedEpisode = focusState
                }
            }
            .animation(.default, value: focus)
        }
    }
#endif
}

// MARK: Artist Item Modifier

extension Modifiers {

#if os(macOS)
    /// A `ViewModifier` to wrap a ``ArtistsView/Item`` for the plaform
    struct ArtistsViewItem: ViewModifier {
        /// The `Artist`
        let artist: Audio.Details.Artist
        /// The currently selected `Artist`
        @Binding var selectedArtist: Audio.Details.Artist?
        /// The modifier
        func body(content: Content) -> some View {
            content
                .tag(artist)
        }
    }
#endif

#if os(tvOS)
    /// A `ViewModifier` to wrap a ``ArtistsView/Item`` for the plaform
    struct ArtistsViewItem: ViewModifier {
        /// The `Artist`
        let artist: Audio.Details.Artist
        /// The currently selected `Artist`
        @Binding var selectedArtist: Audio.Details.Artist?
        /// The focus state
        @FocusState var focusState: Audio.Details.Artist?
        /// Bool if focussed or not
        var focus: Bool {
            return focusState != nil
        }
        /// The modifier
        func body(content: Content) -> some View {
            content
                .saturation(focus ? 1 : 0.5)
                .scaleEffect(focus ? 1.4 : 1)
                .padding(.vertical)
                .shadow(radius: 20)
                .focusable()
            .focused($focusState, equals: artist)
            .task(id: focusState) {
                if let focusState {
                    selectedArtist = focusState
                }
            }
            .animation(.default, value: focus)
        }
    }
#endif
}
