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
    /// The Router model
    @StateObject var router: Router = Router()
    /// The View
    var body: some View {
        NavigationView {
            NavbarView()
            MainView()
                .background(Color(nsColor: .textBackgroundColor))
        }
        .environmentObject(router)
    }
}
