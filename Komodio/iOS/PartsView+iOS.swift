//
//  PartsView+iOS.swift
//  Komodio (iOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

extension PartsView {

    struct TitleHeader: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The View
        var body: some View {
            if let subtitle = appState.filter.subtitle {
                VStack(alignment: .leading, spacing: 0) {
                        Text(subtitle)
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
