//
//  KodiSettingsView+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension KodiSettingsView {

    /// Full screen View for Kodi settings (tvOS)
    struct FullScreen: View {
        /// The SceneState model
        @EnvironmentObject var scene: SceneState

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            NavigationStack {
                VStack {
                    Text("Kodi Settings")
                        .font(.largeTitle)
                    KodiSettingsView.Warning()
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(10)
                        .frame(width: 800)
                        .font(.caption)
                        .padding()
                    KodiSettingsView()
                }
                .navigationDestination(for: Setting.Details.Section.self, destination: { section in
                    KodiSettingsView.Section(section: section)
                })
            }
            .background(.ultraThinMaterial.opacity(0.8))
            .onDisappear {
                scene.details = .start
            }
        }
    }
}
