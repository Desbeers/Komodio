//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI

struct RootView: View {
    /// The Router model
    @StateObject var router: Router = Router()
    /// The View
    var body: some View {
        NavigationView {
            SidebarView()
            HomeView()
        }
        .environmentObject(router)
    }
}
