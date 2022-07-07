//
//  HomeView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// The Home View for Komodio
struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The body of this View
    var body: some View {
        Text("Home View")
    }
}
