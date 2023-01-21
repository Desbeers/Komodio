//
//  KodiHostView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct KodiHostView: View {
    let host: HostItem
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState

    @State private var values = HostItem()

    /// The Presentation mode
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            KodiHostItemView(host: host)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        #if os(tvOS)
        /// Close the view when the host is updated
        .onChange(of: kodi.host) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        #endif
    }
}

extension KodiHostView {

    struct Details: View {
        let host: HostItem
        var body: some View {
            VStack {
                KodiHostItemView.KodiSettings()
                .font(AppState.shared.platform == .macOS ? .title2 : .body)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
}
