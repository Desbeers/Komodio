//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI


struct RootView: View {    
    /// The AppState model
    @StateObject var appState: AppState = AppState()

    /// The Router model
    @StateObject var router: Router = Router()
    
    /// The selection in the list
    @State var selection: String? = "Home"
    /// The View
    var body: some View {
        NavigationView {
            NavbarView()
            //.iOS { $0.navigationTitle("Library") }
            HomeView()
        }
        .environmentObject(appState)
        .environmentObject(router)
        //.edgesIgnoringSafeArea(.bottom)
        //.statusBar(hidden: true)
    }
}
