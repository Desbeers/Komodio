//
//  SidebarView+iOS.swift
//  Komodio (iOS)
//
//  Created by Nick Berendsen on 05/03/2022.
//

import SwiftUI

struct SidebarView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The selection in the sidebar
    @State var selection: Route? = .home
    /// The View
    var body: some View {
        List {
            items
        }
        .navigationTitle("Library")
    }
}

extension SidebarView {
    
    var items: some View {
        ForEach(Route.menuItems, id: \.self) { item in
            NavigationLink(
                destination: item.destination
                    .onAppear {
                        router.routes = [item]
                    }
                    .navigationTitle(item.title),
                tag: item,
                selection: $selection,
                label: { Label(item.title, systemImage: item.symbol) }
            )
        }
    }
}
