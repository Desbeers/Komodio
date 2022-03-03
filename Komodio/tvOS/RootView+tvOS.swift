//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI

import SwiftlyKodiAPI

struct RootView: View {
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The selection in the list
    @State var selection: String?
//    init(){
//        UINavigationBar.setAnimationsEnabled(false)
//    }
    /// The View
    var body: some View {
        StackNavView {
            TabView() {
                NavBarView.Items(selection: $selection)
            }
        }
        .environmentObject(appState)
        //.background(Image("Background").resizable().ignoresSafeArea())
        //.preferredColorScheme(.dark)
    }
}
