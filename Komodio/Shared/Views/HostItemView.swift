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
    /// The SceneState model
    @Environment(SceneState.self) private var scene

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        DetailView.Wrapper(
            scroll: nil,
            part: false,
            title: host.name,
            subtitle: nil
        ) {
            VStack {
                KodiHostItemView(host: host) {
                    _ = scene.navigationStack.popLast()
                    #if !os(macOS)
                    /// - Note: The stack is one step deeper
                    _ = scene.navigationStack.popLast()
                    #endif
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
