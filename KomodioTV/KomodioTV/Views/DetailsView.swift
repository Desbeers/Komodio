//
//  DetailsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct DetailsView: View {
    let item: MediaItem
    var body: some View {
        VStack {
            Text("Details for \(item.title)")
            
            NavigationLink(destination: PlayerView(video: item)) {
                Text("Play")
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ArtView.Background(fanart: item.fanart))
        .ignoresSafeArea()
    }
}
