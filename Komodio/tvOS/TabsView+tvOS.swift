//
//  TabbarView.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 05/03/2022.
//

import SwiftUI

struct TabsView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The View
    var body: some View {
        ForEach(Route.menuItems, id: \.self) { item in
            item.destination
                .onAppear {
                    router.routes = [item]
                }
                .tabItem {
                    Label(item.title, systemImage: item.symbol)
                }
                .tag(item.title)
        }
    }
}

