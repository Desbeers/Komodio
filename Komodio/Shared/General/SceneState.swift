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
//    /// The Navigation path
//    @Published var navigationStackPath = NavigationPath()
//    /// The optional background image
//    @Published var background: (any KodiItem)?
    /// Sidebar focus toggle
    @Published var toggleSidebar: Bool = false

#endif

    // MARK: Shared stuff
    /// The shared instance of this SceneState class
    static let shared = SceneState()
    /// The Navigation path
    @Published var navigationStackPath = NavigationPath()
    /// The optional background image
    @Published var background: (any KodiItem)?
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

    /// Init the ``SceneState``
    private init() {
        listSortSettings = SceneState.loadListSortSettings()
    }
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

extension SceneState {

    /// Load the `List Sort` settings
    /// - Returns: The stored List Sort settings settings
    static func loadListSortSettings() -> [SwiftlyKodiAPI.List.Sort] {
        logger("Get ListSort settings")
        if let settings = Cache.get(key: "ListSort", as: [SwiftlyKodiAPI.List.Sort].self, root: true) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the `List Sort` settings to the cache
    /// - Parameter settings: All the current List Sort settings
    static func saveListSortSettings(settings: [SwiftlyKodiAPI.List.Sort]) {
        do {
            try Cache.set(key: "ListSort", object: settings, root: true)
        } catch {
            logger("Error saving ListSort settings")
        }
    }

    /// Get the `List Sort` settings for a View
    /// - Parameter sortID: The ID of the sorting
    static func getListSortSettings(sortID: String) -> SwiftlyKodiAPI.List.Sort {
        if let sorting = SceneState.shared.listSortSettings.first(where: { $0.id == sortID }) {
            return sorting
        }
        return SwiftlyKodiAPI.List.Sort(id: sortID)
    }
}
