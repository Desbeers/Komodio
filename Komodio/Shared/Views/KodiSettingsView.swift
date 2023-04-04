//
//  KodiSettingsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Kodi Settings View

/// SwiftUI View for Kodi settings (shared)
struct KodiSettingsView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            Text("Kodi Settings")
                .font(.largeTitle)
            Warning()
                .padding()
                .background(.thickMaterial)
                .cornerRadius(10)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial.opacity(0.8))
        .task {
            scene.navigationSubtitle = Router.kodiSettings.label.title
        }
#if os(macOS)
        .toolbar {
            /// Show a 'back' button
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    scene.sidebarSelection = .start
                }, label: {
                    Image(systemName: "chevron.backward")
                })
            }
        }
#endif
    }
}

extension KodiSettingsView {

    // MARK: Kodi Settings Details

    /// SwiftUI View for Kodi settings details
    struct Details: View {

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
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
        }
    }
}

extension KodiSettingsView {

    // MARK: Kodi Settings Warning

    /// SwiftUI View for warning of Kodi settings
    struct Warning: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Label(
                title: {
                    // swiftlint:disable:next line_length
                    Text("These are the **Kodi** settings on '\(kodi.host.name)', not **Komodio** settings.\n\n**Komodio** will use these settings, however, it will affect all clients, not just **Komodio**.")
                }, icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                })
        }
    }
}
