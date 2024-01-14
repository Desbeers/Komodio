//
//  KodiSettingsView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Kodi Settings View

/// SwiftUI `View` for Kodi settings (shared)
struct KodiSettingsView: View {
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        ContentView.Wrapper(
            header: {
                PartsView
                    .DetailHeader(
                        title: "Settings on '\(kodi.host.name)'"
                    )
            },
            content: {
                Grid(
                    alignment: .top,
                    horizontalSpacing: 20,
                    verticalSpacing: 20
                ) {
                    GridRow {
                        KodiSettingView.Warning()
                        KodiSettingView.SingleSetting(setting: .servicesDevicename)
                    }
                    GridRow {
                        KodiSettingView.SingleSetting(setting: .videolibraryShowUwatchedPlots)
                        KodiSettingView.SingleSetting(setting: .videolibraryGroupMovieSets)
                    }
                }
                .backport.focusSection()
                .frame(maxHeight: .infinity)
            },
            buttons: {}
        )
    }
}
