//
//  PlayerView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct PlayerView: View {
    var body: some View {
        Text("PLAYING!!!")
            .font(.title)
#if os(tvOS)
        /// Else we can't keep control of the Siri Munu button
        .focusable(true)
#endif
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
