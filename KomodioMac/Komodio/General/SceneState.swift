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
    /// The current selection in the sidebar
    @Published var sidebar: Router = .movies
    /// The current search query (not in use yet)
    var query: String = ""
    /// The subtitle for the navigation
    @Published var navigationSubtitle: String = "A Kodi client"
    /// The details for the current selection in the main view
    @Published var details: Router = .movies {
        didSet {
            switch details {
            case .movieSet(let movieSet):
                navigationSubtitle = movieSet.title
            case .tvshow(let tvshow):
                navigationSubtitle = tvshow.title
            case .artist(let artist):
                navigationSubtitle = artist.artist
            default:
                break
            }
        }
    }
}
