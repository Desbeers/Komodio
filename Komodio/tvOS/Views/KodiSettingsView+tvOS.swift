//
//  KodiSettingsView+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension KodiSettingsView {

    // MARK: Full Screen

    /// Full screen View for Kodi settings (tvOS)
    struct FullScreen: View {

        // MARK: Body of the View

        /// The body of the View
        var body: some View {

            HStack(spacing: 0) {
                KodiSettingsView()
                    .frame(width: 600)
                KodiSettingsView.Details()
            }
        }
    }
}
