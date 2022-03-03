//
//  MainView.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack {
            
            if let subtitle = router.routes.dropLast().last {
                Text(subtitle.title)
                    .font(.subheadline)
            }
            Text(router.routes.last?.title ?? "No title")
                .font(.title)
            Spacer()
            router.currentRoute.destination
//            if let currentRoute = router.currentRoute {
//                currentRoute.destination()
//            }
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    router.pop()
                },
                       label: {
                    Image(systemName: "chevron.backward.square.fill")
                })
                    .disabled(router.routes.count == 1)
            }
            ToolbarItem {
                Text(router.routes.map { $0.title } .joined(separator: "/"))
            }
        }
        .animation(.default, value: router.currentRoute)
    }
}
