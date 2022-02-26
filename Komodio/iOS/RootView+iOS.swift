//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI
import SwiftUIRouter

struct RootView: View {    
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The selection in the list
    @State var selection: String? = "Home"
    /// The View
    var body: some View {
        StackNavView {
            List(selection: $selection) {
                //Section(header: Text("Library")) {
                    NavBarView.Items(selection: $selection)
                //}
            }
            .navigationTitle("Library")
            HomeView()
        }
        .environmentObject(appState)
        .edgesIgnoringSafeArea(.bottom)
        //.statusBar(hidden: true)
    }
}
