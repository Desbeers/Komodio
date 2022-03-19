//
//  MainView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        ZStack(alignment: .top) {
            if kodi.loadingState == .done, let route = router.routes.last {
                route.route.destination
            } else {
                LoadingView()
            }
            if !router.currentRoute.route.isPlayer {
                VStack {
                    PartsView.TitleHeader()
                    Spacer()
                }
            }
        }
        .fanartBackground(fanart: router.fanart)
        .animation(.default, value: router.currentRoute)
#if os(tvOS)
        /// Take care of the 'menu' button on the Siri remote
        .onExitCommand {
            if router.routes.count > 1 {
                router.pop()
            } else {
                logger("We are at the root")
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            }
        }
#endif
    }
}
