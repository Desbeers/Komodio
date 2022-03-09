//
//  MainView.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        ZStack(alignment: .top) {
            if kodi.loadingState == .done, let route = router.routes.last {
                route.destination
            } else {
                LoadingView()
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
