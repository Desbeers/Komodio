//
//  GenresView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

/// A View for Genre items
struct GenresView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    /// The Router model
    @EnvironmentObject var router: Router
    
#if os(tvOS)
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 320))]
#else
    /// Define the grid layout
    let grid = [GridItem(.adaptive(minimum: 160))]
#endif
    /// The View
    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 30) {
                ForEach(kodi.genres) { genre in
                    
                    RouterLink(item: .genresItems(genre: genre)) {
                        Label(genre.label, systemImage: genre.symbol)
                            .labelStyle(LabelStyles.GridItem())
                            .tvOS { $0.frame(width: 260, height: 120) }
                            .macOS { $0.frame(width: 130, height: 60) }
                    }

                }
                .buttonStyle(ButtonStyles.GridItem())
            }
            .macOS { $0.padding(.top, 40) }
        }
        .task {
            print("GenresView task!")
            /// Set the filter
            appState.filter = KodiFilter(media: .none,
                                         title: "Genres",
                                         subtitle: nil,
                                         fanart: nil
            )
        }
        .iOS { $0.navigationTitle("Genres") }
        .tvOS { $0.padding(.horizontal, 100) }
    }
}

extension GenresView {
    
    /// A view with all items of a certain genre
    struct Items: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        
        /// The Router model
        @EnvironmentObject var router: Router
        
        /// The selected Genre to filter
        let genre: GenreItem
        /// The list of Kodi items to show
        @State var items: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List() {
#if os(tvOS)
            PartsView.TitleHeader()
#endif
                ForEach(items) { item in
                    ItemsView.Item(item: item.binding())
                }
            }
            .task {
                print("GenresView.Items task!")
                /// Set the filter
                appState.filter = KodiFilter(media: .all,
                                             title: genre.label,
                                             subtitle: "Genres",
                                             fanart: nil,
                                             setID: nil,
                                             genre: genre.label)
                /// Get the items
                items = kodi.library.filter(appState.filter)
            }
            .iOS { $0.navigationTitle(genre.label) }
        }
    }
}
