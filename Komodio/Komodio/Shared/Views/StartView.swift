//
//  StartView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension StartView {

    struct Details: View {

        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The SceneState model
        @EnvironmentObject var scene: SceneState

        /// Rotate the record
        @State private var rotate: Bool = false

        var body: some View {
            VStack {
                Text(kodi.state.rawValue)
#if os(macOS)
                    .font(.largeTitle)
                    .padding()
#endif
#if os(tvOS)
                    .font(.headline)
#endif
                Parts.RotatingIcon(rotate: $rotate)
                    .task(id: kodi.state) {
                        rotate = kodi.state == .loadedLibrary ? true : false
                    }
            }
        }
    }
}
