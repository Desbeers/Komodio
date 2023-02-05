//
//  HostItemView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for settings to connect to a Kodi host (shared)
///
/// - On macOS, in the ``ContentView``; selected from the ``SidebarView``
/// - On tvOS, on a 'full screen' View, selected from the ``StartView``
struct HostItemView: View {
    /// The `HostItem` to edit
    let host: HostItem
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The Presentation mode (tvOS)
    @Environment(\.presentationMode) private var presentationMode

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack {
            KodiHostItemView(host: host)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)

#if os(macOS)
        /// Goto 'start' when a host is updated
        .onChange(of: kodi.configuredHosts) { _ in
            scene.sidebarSelection = .start
        }
#endif

#if os(tvOS)
        /// Close the view when the host is updated
        .onChange(of: kodi.host) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onChange(of: kodi.configuredHosts) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .onChange(of: kodi.status) { _ in
            presentationMode.wrappedValue.dismiss()
        }
#endif
    }
}

extension HostItemView {

    // MARK: Kodi settings to connect to Komodio

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
