//
//  KodiSettingsView+Details.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//


import SwiftUI
import SwiftlyKodiAPI

extension KodiSettingsView {

    // MARK: Kodi Settings Details

    /// SwiftUI `View` for Kodi settings details
    struct Details: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self) private var kodi

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: "KodiSettings",
                part: StaticSetting.platform == .macOS ? false : true,
                title: "Settings on '\(kodi.host.name)'"
            ) {
                ScrollView {
                    KodiSettingView.Warning()
                        .padding([.top, .horizontal])
                    KodiSettingView.SingleSetting(setting: .servicesDevicename)
                        .padding([.top, .horizontal])
                    KodiSettingView.SingleSetting(setting: .videolibraryShowUwatchedPlots)
                        .padding([.top, .horizontal])
                    KodiSettingView.SingleSetting(setting: .videolibraryGroupMovieSets)
                        .padding([.top, .horizontal])
                }
            }
        }
    }
}
