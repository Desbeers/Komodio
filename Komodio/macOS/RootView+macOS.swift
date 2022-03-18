//
//  RootView+macOS.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The Root View of Komodio
struct RootView: View {
    /// The Router model
    @StateObject var router: Router = Router()
    /// The View
    var body: some View {
        NavigationView {
            SidebarView()
            MainView()
                .background(Color(nsColor: .textBackgroundColor))
        }
        .environmentObject(router)
    }
}
