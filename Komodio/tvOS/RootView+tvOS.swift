//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI

import SwiftlyKodiAPI

struct RootView: View {
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
        .environmentObject(router)
    }
}
