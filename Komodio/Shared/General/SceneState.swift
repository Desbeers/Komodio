//
//  SceneState.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Class to observe the current Komodio Scene state (shared)
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
    /// Bool to show the Kodi Settings View
    @Published var showSettings: Bool = false
    /// Sidebar focus toggle
    @Published var toggleSidebar: Bool = false
#endif

    // MARK: Shared stuff
    /// The shared instance of this SceneState class
    static let shared = SceneState()
    /// The Navigation path
    @Published var navigationStackPath = NavigationPath()
    /// The settings to sort a list
    var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []
    /// The current selection in the ``SidebarView``
    @Published var sidebarSelection: Router = .start
    /// The subtitle for the navigation
    @Published var navigationSubtitle: String = ""
    /// The details for the current selection in the main view
    @Published var details: Router = .start
    /// Movie ID's passed around Views
    @Published var movieItems: [Int] = []
    /// The optional current selected KodiItem
    var selectedKodiItem: (any KodiItem)?

//    /// Init the ``SceneState``
//    private init() {
//        listSortSettings = SceneState.loadListSortSettings()
//    }
}

extension SceneState {

#if os(macOS)
    /// Update the search query
    /// - Parameter query: The query in the UI
    @MainActor func updateSearch(query: String) async {
        do {
            try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            self.query = query
            if !query.isEmpty {
                sidebarSelection = .search
            } else if sidebarSelection == .search {
                /// Go to the main browser view; the search is canceled
                sidebarSelection = .start
            }
        } catch { }
    }
#endif
}
