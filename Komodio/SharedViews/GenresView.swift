//
//  GenresView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

/// A View for Genre items
struct GenresView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
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
                    
                    StackNavLink(path: "/Genres/\(genre.label)",
                                 filter: KodiFilter(media: .none),
                                 destination: GenresView.Items(genre: genre)
                    ) {
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
            appState.filter.title = "Genres"
            appState.filter.subtitle = nil
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
        /// The Navigator model
        @EnvironmentObject var navigator: Navigator
        /// The selected Genre to filter
        let genre: GenreItem
        /// The list of Kodi items to show
        @State var items: [KodiItem] = []
        /// The View
        var body: some View {
            ItemsView.List() {
                ForEach(items) { item in
//                    StackNavLink(path: "\(navigator.path)/Details/\(item.id)",
//                                 filter: appState.filter,
//                                 destination: DetailsView(item: item.binding())
//                    ) {
                        ItemsView.Item(item: item.binding())
//                    }
//                    .buttonStyle(ButtonStyles.KodiItem(item: item))
                    
                }
            }
            .task {
                let filter = KodiFilter(media: .all, genre: genre.label)
                items = kodi.library.filter(filter)
                appState.filter.title = genre.label
                appState.filter.subtitle = "Genres"
            }
            .iOS { $0.navigationTitle("Genres") }
            
        }
    }
}
