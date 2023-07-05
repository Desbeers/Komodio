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

#if os(macOS) || os(iOS)
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
#endif

    // MARK: Shared stuff
    /// The shared instance of this SceneState class
    static let shared = SceneState()

    private init() {}

    /// # Router

    /// The main selection of the router
    @Published var mainSelection: Router = .start {
        didSet {
            details = mainSelection
        }
    }
    /// The Navigation stack path of the router
    @Published var navigationStackPath = NavigationPath() {
        didSet {
            if navigationStackPath.isEmpty {
                details = mainSelection
            }
        }
    }
    /// The details for the current selection in the main view
    @Published var details: Router = .start

    /// # Other stuff

    /// The settings to sort a list
    var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []
    /// Movie ID's passed around Views
    @Published var movieItems: [Int] = []
}

extension SceneState {

#if os(macOS) || os(iOS)
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
