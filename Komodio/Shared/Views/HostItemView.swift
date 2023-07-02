//
//  HostItemView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Host Item View

/// SwiftUI View for settings to connect to a Kodi host (shared)
struct HostItemView: View {
    /// The `HostItem` to edit
    let host: HostItem
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The Presentation mode
    @Environment(\.presentationMode) private var presentationMode

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            KodiHostItemView(host: host) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension HostItemView {

    // MARK: Host Item Kodi Settings

    /// SwiftUI View for Kodi settings to connect to Komodio
    struct KodiSettings: View {

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                KodiHostItemView.KodiSettings()
                .font(KomodioApp.platform == .macOS ? .title2 : .body)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
}
