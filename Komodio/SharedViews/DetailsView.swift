//
//  DetailsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct DetailsView: View {
    
    let item: KodiItem
    
    /// The route navigation
    @EnvironmentObject var routeInformation: RouteInformation
    
    var body: some View {
        VStack {
        Text("Item details!")
                .font(.title)
            Text(item.title)
                .font(.headline)
            NavLink(to: "/Player") {
                Text("Play!!")
            }
        }
        .task {
            print("DetailsView task!")
        }
    }
}
