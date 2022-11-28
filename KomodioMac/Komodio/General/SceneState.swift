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
    /// The current selection in the main view
    @Published var selection = Selection()
    /// The current search query
    var query: String = ""
    /// The navigation selection
    struct Selection: Equatable {
        /// Where are we in the application
        var route: Router = .start
        /// The selected item (Can be any KodiItem)
        var mediaItem: MediaItem?
        /// The selected movie
        var movie: Video.Details.Movie?
        /// The selected movie set
        var movieSet: Video.Details.MovieSet?
        /// The selected TV show
        var tvshow: Video.Details.TVShow?
        /// The selected Season
        var season: Int?
    }
}
