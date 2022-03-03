//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI

import SwiftlyKodiAPI

struct RootView: View {
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Router model
    @StateObject var router: Router = Router()
//    init(){
//        UINavigationBar.setAnimationsEnabled(false)
//    }
    /// The View
    var body: some View {
        NavigationView {
            TabView() {
                NavbarView.Items(selection: $router.navbar)
            }
        }
        .environmentObject(appState)
        .environmentObject(router)
        //.background(Image("Background").resizable().ignoresSafeArea())
        //.preferredColorScheme(.dark)
    }
}
