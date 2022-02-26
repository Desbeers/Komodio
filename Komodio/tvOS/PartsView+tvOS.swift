//
//  PartsView+tvOS.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

extension PartsView {

    struct TitleHeader: View {
        /// The Kodi item
        let item: KodiItem
        /// The View
        var body: some View {
            if !item.title.isEmpty {
                VStack(spacing: 0) {
                    Text(item.title)
                        .font(.title2)
                    if !item.subtitle.isEmpty {
                        Text(item.subtitle)
                            .font(.body)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
            }
        }
    }
}
