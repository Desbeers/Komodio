//
//  SceneState.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Class to observe the current Komodio Scene state
class SceneState: ObservableObject {

    // MARK: macOS stuff

#if os(macOS)
    /// The current search query
   var query: String = ""
#endif

    // MARK: tvOS stuff

#if os(tvOS)
    /// The current search query
    @Published var query: String = ""
    /// Router items to show in the sidebar
    let sidebarItems: [Router] = [
        .start,
        .movies,
        .unwatchedMovies,
        .tvshows,
        .unwachedEpisodes,
        .musicVideos,
        .search
    ]
    /// The main selection of Komodio
    var mainSelection: Int = 0 {
        didSet {
            /// Set the sidebar selection as a ``Router`` item
            sidebarSelection = sidebarItems[mainSelection]
            /// Reset the details
            details = sidebarItems[mainSelection]
            /// Set the contentSelection
            contentSelection = sidebarItems[mainSelection]
            /// Reset the navigationStackPath
            navigationStackPath = NavigationPath()
            /// Reset the background
            background = nil
        }
    }
    /// Bool to show the Kodi Settings View
    @Published var showSettings: Bool = false
    /// The Naigation path
    @Published var navigationStackPath = NavigationPath()
    /// The optional background image
    @Published var background: String?

#endif

    // MARK: Shared stuff

    /// The current selection in the ``SidebarView``
    @Published var sidebarSelection: Router = .start
    /// The current selection in the ``ContentView``
    @Published var contentSelection: Router = .start
    /// The subtitle for the navigation
    @Published var navigationSubtitle: String = ""
    /// The details for the current selection in the main view
    @Published var details: Router = .start {
        didSet {
            switch details {
            case .start:
                navigationSubtitle = ""
            case .movieSet(let movieSet):
                navigationSubtitle = movieSet.title
            case .tvshow(let tvshow):
                navigationSubtitle = tvshow.title
            case .artist(let artist):
                navigationSubtitle = artist.artist
            case .search:
                navigationSubtitle = Router.search.label.title
            default:
                break
            }
        }
    }
}

extension SceneState {

#if os(macOS)

    /// Update the search query
    /// - Parameter query: The query in the UI
    func updateSearch(query: String) async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
//            self.query = query
            Task { @MainActor in
                self.query = query
                if !query.isEmpty {
                    sidebarSelection = .search
                } else if sidebarSelection == .search {
                    /// Go to the main browser view; the search is canceled
                    sidebarSelection = .movies
                }
            }
        } catch { }
    }
#endif
}
