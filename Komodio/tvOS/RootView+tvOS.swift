//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI
import SwiftlyKodiAPI

struct RootView: View {
    /// The Router model
    @StateObject var router = Router()
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The View
    var body: some View {
        if kodi.loadingState == .done {
            MainView()
                .environmentObject(router)
        } else {
            LoadingView()
        }
    }
}
