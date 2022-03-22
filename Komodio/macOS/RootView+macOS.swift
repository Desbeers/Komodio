//
//  RootView+macOS.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct RootView: View {
    /// The Router model
    @StateObject var router: Router = .shared
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The View
    var body: some View {
        if kodi.loadingState == .done {
            MainView()
                .background(Color.accentColor.blendMode(.screen))
                .environmentObject(router)
        } else {
            LoadingView()
        }
    }
}
