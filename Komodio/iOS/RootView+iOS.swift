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
    /// The View
    var body: some View {
        
        if kodi.loadingState == .done {
            NavigationView {
                SidebarView()
                HomeView()
            }
            .environmentObject(router)
        } else {
            LoadingView()
        }
        
        
//        NavigationView {
//            SidebarView()
//            HomeView()
//        }
//        .environmentObject(router)
    }
}
