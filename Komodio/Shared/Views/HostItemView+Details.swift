//
//  HostItemView+Details.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
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
            DetailView.Wrapper(
                scroll: nil,
                part: StaticSetting.platform == .macOS ? false : true,
                title: "Get remote access",
                subtitle: nil
            ) {
                KodiHostItemView.KodiSettings()
                    .font(StaticSetting.platform == .macOS ? .title2 : .body)
                    .frame(maxHeight: .infinity)
            }
        }
    }
}
