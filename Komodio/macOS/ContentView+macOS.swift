//
//  ContentView.swift
//  Shared
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

// MARK: - Routes

/// The one and only content page for macOS
struct ContentView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The View
    var body: some View {
        ZStack(alignment: .top) {
            SwitchRoutes {
                /// Home
                Group {
                    Route("Home/", content: HomeView())
                    Route("Home/Details/:itemID", validator: validateItemID) { itemID in
                        DetailsView(item: itemID.binding())
                    }
                }
                /// Movies
                Group {
                    Route("Movies/", content: MoviesView(
                        filter: KodiFilter(media: .movie,
                                           title: "Movies",
                                           subtitle: nil)
                    ))
                    Route("Movies/Set/:setID") { info in
                        MoviesView.MovieSetView(setID: Int(info.parameters["setID"]!)!)
                    }
                    Route("Movies/Details/:itemID", validator: validateItemID) { itemID in
                        DetailsView(item: itemID.binding())
                    }
                }
                /// TV shows
                Group {
                    Route("TV shows/", content: TVshowsView(
                        filter: KodiFilter(media: .tvshow,
                                           title: "TV shows",
                                           subtitle: nil)
                    ))
                    Route("TV shows/Episodes/:itemID", validator: validateItemID) { showID in
                        EpisodesView(tvshow: showID)
                    }
                    Route("TV shows/Episodes/Details/:itemID", validator: validateItemID) { itemID in
                        DetailsView(item: itemID.binding())
                    }
                }
                /// Music Videos
                Group {
                    Route("Music Videos/", content: MusicVideosView(
                        filter: KodiFilter(media: .musicvideo,
                                           title: "Music Videos",
                                           subtitle: nil)
                    ))
                    Route("Music Videos/Artist/:itemID", validator: validateItemID) { kodiItem in
                        MusicVideosView.Items(artist: kodiItem)
                    }
                    Route("Music Videos/Artist/Details/:itemID", validator: validateItemID) { itemID in
                        DetailsView(item: itemID.binding())
                    }
                }
                /// Genres
                Group {
                    
                    Route("Genres", content: GenresView())
                    
                    Route("Genres/:itemID", validator: validateGenreID) { genreItem in
                        GenresView.Items(genre: genreItem)
                    }
                    ForEach(kodi.genres) { genre in
                        Route("\(genre.label)", validator: validateGenreLabel) { genreItem in
                            GenresView.Items(genre: genreItem)
                        }
                        Route("Genres/\(genre.label)/Details/:itemID", validator: validateItemID) { itemID in
                            DetailsView(item: itemID.binding())
                        }
                        Route("\(genre.label)/Details/:itemID", validator: validateItemID) { itemID in
                            DetailsView(item: itemID.binding())
                        }
                    }
                }
                /// Fallback
                Route {
                    let _ = print("Genre Detail??")
                    Navigate(to: "Home")
                }
            }
            .navigationTransition()
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        .fanartBackground()
    }

    /// Get a Kodi item from an ID string
    /// - Parameter routeInfo: The route info with the details
    /// - Returns: A ``KodItem``
    func validateItemID(routeInfo: RouteInformation) -> KodiItem {
        let id = routeInfo.parameters["itemID"] ?? ""
        let item = kodi.library.first(where: { $0.id == id })!
        return item
    }
    
    /// Get a Kodi genre from an ID string
    /// - Parameter routeInfo: The route info with the details
    /// - Returns: A ``KodItem``
    func validateGenreID(routeInfo: RouteInformation) -> GenreItem {
        let label = routeInfo.parameters["itemID"] ?? "unknown"
        let item = kodi.genres.first(where: { $0.label == label })!
        return item
    }
    
    /// Get a Kodi genre from an Label string
    /// - Parameter routeInfo: The route info with the details
    /// - Returns: A ``KodItem``
    func validateGenreLabel(routeInfo: RouteInformation) -> GenreItem {
        let item = kodi.genres.first(where: { $0.label == String(routeInfo.path.dropFirst())  })!
        return item
    }
    
}
