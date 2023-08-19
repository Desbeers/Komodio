//
//  KodiSettingsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Kodi Settings View

/// SwiftUI `View` for Kodi settings (shared)
struct KodiSettingsView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        ContentView.Wrapper(
            header: {
                PartsView
                    .DetailHeader(
                        title: "Kodi Settings"
                    )
            },
            content: {
                HStack(alignment: .top, spacing: 0) {
                    Warning()
#if canImport(UIKit)
                    Details()
#endif
                }
            },
            buttons: {}
        )
    }
}

extension KodiSettingsView {

    // MARK: Kodi Settings Warning

    /// SwiftUI `View` for warning of Kodi settings
    struct Warning: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Label(
                title: {
                    // swiftlint:disable:next line_length
                    Text("These are the **Kodi** settings on '\(kodi.host.name)', not **Komodio** settings.\n\n**Komodio** will use these settings, however, it will affect all clients, not just **Komodio**.")
                }, icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            )
            .padding()
            .background(.thickMaterial)
            .cornerRadius(10)
            .padding()
        }
    }
}
