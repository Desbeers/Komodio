//
//  SceneState.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Class to observe the current Komodio Scene state
class SceneState: ObservableObject {
    /// The current selection in the ``SidebarView``
    @Published var sidebarSelection: Router = .start {
        willSet {
            /// Reset the details
            //details = newValue
        }
    }
    /// The current selection in the ``ContentView``
    @Published var contentSelection: Router = .start {
        didSet {

        }
    }
    /// The current search query
    var query: String = ""
    /// The subtitle for the navigation
    @Published var navigationSubtitle: String = ""
    /// The details for the current selection in the main view
    @Published var details: Router = .start {
        didSet {
            switch details {
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
    func updateSearch(query: String) async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            self.query = query
            Task { @MainActor in
                if !query.isEmpty {
                    sidebarSelection = .search
                } else if sidebarSelection == .search {
                    /// Go to the main browser view; the search is canceled
                    sidebarSelection = .movies
                }
            }
        } catch { }
    }
}
