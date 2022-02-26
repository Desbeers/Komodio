//
//  MoviesView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter

struct MoviesView: View {
    
    @EnvironmentObject var routeInformation: RouteInformation
    
    var body: some View {
        VStack {
            Text("Movies View!")

            
            NavLink(to: "/Movies/Set/20") {
                Text("Take me to **Movie Set 10**")
            }
            NavLink(to: "/Movies/Details/6") {
                Text("Take me to **Details Movie 6**")
            }
        }
        .task {
            dump(routeInformation)
        }
    }
}

extension MoviesView {

    struct Set: View {
        let setID: Int
        var body: some View {
            Text("Movie Set View!")
        }
    }
}
