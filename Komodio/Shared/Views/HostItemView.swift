//
//  HostItemView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Host Item View

/// SwiftUI `View` for settings to connect to a Kodi host (shared)
struct HostItemView: View {
    /// The `HostItem` to edit
    let host: HostItem
    /// The dismiss action
    @Environment(\.dismiss) private var dismiss

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            KodiHostItemView(host: host) {
                dismiss()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
