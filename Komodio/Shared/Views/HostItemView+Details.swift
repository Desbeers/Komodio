//
//  HostItemView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension HostItemView {

    // MARK: Host Item Kodi Settings

    /// SwiftUI `View` for Kodi settings to connect to Komodio
    struct Details: View {

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            VStack {
                KodiHostItemView.KodiSettings()
                    .font(KomodioApp.platform == .macOS ? .title2 : .body)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
}
