//
//  SidebarView.swift
//  Komodio (iOS)
//
//  Created by Nick Berendsen on 05/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Router model
    @EnvironmentObject var router: Router
    /// The View
    var body: some View {
        List(selection: $router.navbar) {
            Section(header: Text("Library")) {
                items
            }
            Section(header: Text("Debug")) {
                Label(Route.table.title, systemImage: Route.table.symbol)
                    .tag(Route.table)
            }
            Section(header: Text("Genres")) {
                genres
            }
        }
        .onExitCommand {
            router.pop()
        }
    }
}

extension SidebarView {
    
    var items: some View {
        ForEach(Route.menuItems, id: \.self) { item in
            Label(item.title, systemImage: item.symbol)
        }
    }
    
    var genres: some View {
        ForEach(kodi.media.filter(MediaFilter(media: .genre))) { genre in
            Label(genre.title, systemImage: genre.poster)
                .tag(Route.genresItems(genre: genre))
        }
    }
}
