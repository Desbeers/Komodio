//
//  SidebarView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import SwiftUIRouter

/// The View for the Sidebar
struct NavBarView { }

extension NavBarView {
    
    /// A View with 'standard' items for a Sidebar or Tabbar
    struct Items: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The binding for the list
        @Binding var selection: String?
        /// The view
        var body: some View {
            StackNavItem(title: "Home",
                        icon: "house",
                         destination: HomeView(),
                         tag: "home",
                        selection: $selection
            )
            StackNavItem(title: "Movies",
                        icon: "film",
                        destination: MoviesView(filter: KodiFilter(media: .movie)),
                         tag: "movies",
                        selection: $selection
            )
            StackNavItem(title: "TV shows",
                        icon: "tv",
                        destination: TVshowsView(filter: KodiFilter(media: .tvshow)),
                         tag: "tvshows",
                        selection: $selection
            )
            StackNavItem(title: "Music Videos",
                        icon: "music.quarternote.3",
                        destination: MusicVideosView(filter: KodiFilter(media: .musicvideo)),
                         tag: "musicvideos",
                        selection: $selection
            )
            StackNavItem(title: "Genres",
                        icon: "list.star",
                        destination: GenresView(),
                         tag: "genres",
                        selection: $selection
            )
        }
    }
    
    /// A View for the Sidebar with all the genres from the Kodi host
    struct Genres: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The binding for the list
        @Binding var selection: String?
        /// The view
        var body: some View {
            ForEach(kodi.genres) { genre in
                Label(genre.label, systemImage: genre.symbol)
                    .tag("\(genre.label)")
            }
        }
    }
}
