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
            Spacer()
//            PartsView.RotatingIcon()
//                .frame(width: 300, height: 300)
            HStack {
                ProgressView()
                Text(kodi.loadingState.rawValue)
                    .font(.caption)
                    .opacity(0.6)
                    .padding(.leading)
            }
            Spacer()
        }
        .animation(.default, value: kodi.loadingState)
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        //.fanartBackground(fanart: router.fanart)
    }
}
