//
//  SceneState.swift
//  KomodioMac
//
//  Created by Nick Berendsen on 23/10/2022.
//

import Foundation
import SwiftlyKodiAPI

/// The class to observe the current Kodio Scene state
class SceneState: ObservableObject {
    /// The current selection in the sidebar
    @Published var selection: Router = .movies
    /// The current search query
    var query: String = ""

    /// The selected video (Can be any KodiItem)
    @Published var selectedMedia: MediaSelection?

    /// The selected movie
    @Published var selectedMovie: Video.Details.Movie?
    /// The selected movie set
    @Published var selectedMovieSet: Video.Details.MovieSet?
    /// The selected TV show
    @Published var selectedTVShow: Video.Details.TVShow?
    /// The selected Season
    @Published var selectedSeason: Int?
    /// The status of the view
    @Published var status: Status = .loading
    
    
    struct MediaSelection: Hashable {
        var id: String
        var media: Library.Media
    }
    
    enum Status {
        
        /// The Task is loading the items
        case loading
        /// No items where found by the `Task`
        case empty
        /// The `Task` is done and items where found
        case ready
        case movies
        case movieSet
        case tvshows
        case episodes
    }
}
