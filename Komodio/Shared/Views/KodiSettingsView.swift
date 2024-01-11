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

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        ContentView.Wrapper(
            header: {
                PartsView
                    .DetailHeader(
                        title: "Settings on '\(KodiConnector.shared.host.name)'"
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
                        KodiSettingView.setting(for: .servicesDevicename)
                    }
                    GridRow {
                        KodiSettingView.setting(for: .videolibraryShowuUwatchedPlots)
                        KodiSettingView.setting(for: .videolibraryGroupMovieSets)
                    }
                }
                .backport.focusSection()
                .frame(maxHeight: .infinity)
            },
            buttons: {}
        )
    }
}
