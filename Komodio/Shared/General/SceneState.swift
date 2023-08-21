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

#if os(macOS) || os(iOS) || os(visionOS)
    /// The current search query
    @Published var query: String = ""
#endif

    // MARK: tvOS stuff

#if os(tvOS)
    /// The current search query
    @Published var query: String = ""
    /// Bool to show the Kodi Settings View
    @Published var showSettings: Bool = false
    /// Sidebar focus toggle
    @Published var toggleSidebar: Bool = false
    /// Sidebar focus state
    @Published var sidebarFocus: Bool = false
#endif

    // MARK: Shared stuff
    /// The shared instance of this SceneState class
    static let shared = SceneState()

    /// Private init of the class
    private init() {}

    /// # Router

    /// The main selection of the router
    @Published var mainSelection: Router = .start
    /// The Navigation stack path of the router
    @Published var navigationStack: [Router] = []
    /// The detail selection of the router
    @Published var detailSelection: Router = .start

    /// # Other stuff

    /// The settings to sort a list
    var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []
    /// Movie ID's passed around Views
    @Published var movieItems: [Int] = []
    /// The list style of collections
    @Published var collectionStyle: ScrollCollectionStyle = .asGrid
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
