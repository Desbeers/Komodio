//
//  PartsView+iOS.swift
//  Komodio (iOS)
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
            if !item.subtitle.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                        Text(item.subtitle)
                            .font(.body)
                            .padding(.bottom, 8)
                            .padding(.leading, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(uiColor: .systemBackground))
            }
        }
    }
}
