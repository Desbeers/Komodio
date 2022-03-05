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
            
            if let route = router.routes.last {
                route.destination
            }
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        .fanartBackground(fanart: router.fanart)
        .animation(.default, value: router.currentRoute)
    }
}
