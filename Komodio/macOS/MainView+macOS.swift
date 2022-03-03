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
        ZStack(alignment: .top) {
            router.currentRoute.destination
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        .fanartBackground()
        .animation(.default, value: router.currentRoute)
    }
}
