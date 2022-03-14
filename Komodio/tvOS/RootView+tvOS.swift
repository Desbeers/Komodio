//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI

import SwiftlyKodiAPI

struct RootView: View {
    /// The Router model
    @StateObject var router: Router = Router()
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
//    init(){
//        UINavigationBar.setAnimationsEnabled(false)
//    }
    /// The View
    var body: some View {
        if kodi.loadingState == .done {
            NavigationView {
                TabView() {
                    TabsView()
                }
            }
            .environmentObject(router)
        } else {
            LoadingView()
        }
    }
}
