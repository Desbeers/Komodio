//
//  KodiSettingsView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//


import SwiftUI
import SwiftlyKodiAPI

extension KodiSettingsView {

    // MARK: Kodi Settings Details

    /// SwiftUI `View` for Kodi settings details
    struct Details: View {

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: "KodiSettings",
                part: KomodioApp.platform == .macOS ? false : true,
                title: "Settings on '\(KodiConnector.shared.host.name)'"
            ) {
                ScrollView {
                    KodiSettingView.setting(for: .servicesDevicename)
                        .padding([.top, .horizontal])
                    KodiSettingView.setting(for: .videolibraryShowuUwatchedPlots)
                        .padding([.top, .horizontal])
                    KodiSettingView.setting(for: .videolibraryGroupMovieSets)
                        .padding([.top, .horizontal])
                }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial.opacity(0.8))
                .cornerRadius(KomodioApp.cornerRadius)
            }
        }
    }
}
