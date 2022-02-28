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
    
    /// Show the optional title and subtitle on a View
    ///
    /// - Note: We can't control the page animations on tvOS, so we just hide
    /// this view as soon as a new header is set. Ugly, but else the header for the next
    /// View is shown before the previous View is gone.
    struct TitleHeader: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// Visible or not
        @State var visible: Bool = false
        /// The View
        var body: some View {
            Group {
                if visible, let title = appState.filter.title {
                    VStack {
                        Text(title)
                            .font(.title)
                        if let subtitle = appState.filter.subtitle {
                            Text(subtitle)
                        }
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(12)
                }
            }
            .onChange(of: appState.filter) { _ in
                print("Header filter changed!")
                visible.toggle()
            }
        }
    }
}
