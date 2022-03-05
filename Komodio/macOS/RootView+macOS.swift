//
//  RootView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

/// The Root View of Komodio
struct RootView: View {
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Router model
    @StateObject var router: Router = Router()
//    /// The selection in the list
//    @State private var selection: String?
    /// The View
    var body: some View {
        NavigationView {
            NavbarView()
            MainView()
                .background(Color(nsColor: .textBackgroundColor))
        }
        .environmentObject(appState)
        .environmentObject(router)
    }
}
