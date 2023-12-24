//
//  SceneState.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Class to observe the current Komodio Scene state (shared)
@Observable class SceneState {

    // MARK: tvOS stuff

#if os(tvOS)
    /// Bool to show the Kodi Settings View
    var showSettings: Bool = false
    /// Sidebar focus toggle
    var toggleSidebar: Bool = false
    /// Sidebar focus state
    var sidebarFocus: Bool = false
#endif

    // MARK: Shared stuff

    /// # Router

    /// The main selection of the router
    var mainSelection: Router = .start
    /// The Navigation stack path of the router
    var navigationStack: [Router] = []
    /// The detail selection of the router
    var detailSelection: Router = .start

    /// # Search

    var query: String = ""

    /// # Other stuff

    /// The settings to sort a list
    var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []
    /// Movie ID's passed around Views
    var movieItems: [Int] = []
    /// The list style of collections
    var collectionStyle: ScrollCollectionStyle = .asGrid
    /// Show the inspector (macOS)
    var showInspector: Bool = false
}

extension SceneState {

#if os(macOS) || os(iOS) || os(visionOS)
    /// Update the search query
    /// - Parameter query: The query in the UI
    @MainActor func updateSearch(query: String) async {
        do {
            try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            self.query = query
            if !query.isEmpty {
                mainSelection = .search
            } else if mainSelection == .search {
                /// Go to the main browser view; the search is canceled
                mainSelection = .start
            }
        } catch { }
    }
#endif
}
