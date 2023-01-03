//
//  KodiSettingsView+tvOS.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 31/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

extension KodiSettingsView {

    /// Full screen View for Kodi settings
    struct FullScreen: View {
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
                NavigationStack {
                    VStack {
                        Text("Kodi Settings")
                            .font(.largeTitle)
                        // swiftlint:disable:next line_length
                        Label("These are the *Kodi* settings on your host, not *Komodio* settings. **Komodio** might or might not behave according these preferences and they might not be relevant here at all", systemImage: "exclamationmark.circle.fill")
                            .padding()
                            .background(.thickMaterial)
                            .cornerRadius(10)
                            .frame(width: 800)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                        KodiSettingsView()
                    }
                        .navigationDestination(for: Setting.Details.Section.self, destination: { section in
                            KodiSettingsView.Section(section: section)
                        })
                }
        }
    }
}
