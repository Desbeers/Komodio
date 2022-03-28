//
//  KomodioView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher

struct KomodioView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
        Button(action: {
            Task {
                await kodi.reloadHost()
            }
        }, label: {
            Text("Reload Library")
                .padding()
        })
        .padding(.all, 40)
        Button(action: {
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache { print("Done") }
        }, label: {
            Text("Clear Art")
                .padding()
        })
        .padding(.all, 40)
        }
        .padding(200)
    }
}
