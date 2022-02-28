//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct RootView: View {
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The selection in the list
    @State var selection: String?
    /// The View
    var body: some View {
        StackNavView {
            TabView() {
                NavBarView.Items(selection: $selection)
            }
        }
        //.animation(nil, value: selection)
        //.background(Color("tvOSbackground"))
        .environmentObject(appState)
        .background(Image("Background").resizable().ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
