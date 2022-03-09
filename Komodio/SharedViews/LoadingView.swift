//
//  LoadingView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct LoadingView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            Spacer()
            Text("Loading your library")
                .font(.title)
            ProgressView()
            Spacer()
            Text(kodi.loadingState.rawValue)
            Spacer()
        }
        .animation(.default, value: kodi.loadingState)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.fanartBackground(fanart: router.fanart)
    }
}
