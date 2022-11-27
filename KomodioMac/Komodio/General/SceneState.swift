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
    @Published var sidebar: Router = .movies
    /// The current selection in the main view
    @Published var selection = Selection()
    /// The current search query
    var query: String = ""

//    /// The selected video (Can be any KodiItem)
//    @Published var selectedMedia: MediaSelection?
//
//    /// The selected movie
//    @Published var selectedMovie: Video.Details.Movie?
//    /// The selected movie set
//    @Published var selectedMovieSet: Video.Details.MovieSet?
//    /// The selected TV show
//    @Published var selectedTVShow: Video.Details.TVShow?
//    /// The selected Season
//    @Published var selectedSeason: Int?
//    /// The status of the view
//    @Published var status: Status = .loading
    
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
    

    
//    enum Status {
//        
//        /// The Task is loading the items
//        case loading
//        /// No items where found by the `Task`
//        case empty
//        /// The `Task` is done and items where found
//        case ready
//        case movies
//        case movieSet
//        case tvshows
//        case episodes
//    }
}
