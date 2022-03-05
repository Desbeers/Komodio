//
//  PartsView+tvOS.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

extension PartsView {
    
    /// Show the title and optional subtitle on a View
    struct TitleHeader: View {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The View
        var body: some View {
            VStack(alignment: .leading) {
                if let subtitle = router.subtitle {
                    Text(subtitle)
                        .padding(.leading, 2)
                        .font(.subheadline)
                } else {
                    Text(" ")
                }
                Text(router.title)
                    .font(.title)
            }
            .animation(.default, value: router.title)
            .padding(.leading, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
            .background(.ultraThinMaterial)
        }
    }
}
