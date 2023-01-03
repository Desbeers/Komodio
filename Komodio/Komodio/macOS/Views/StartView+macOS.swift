//
//  StartView+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View when starting Komodio
struct StartView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            switch kodi.state {
            case .loadedLibrary:
                VStack(spacing: 20) {
                    StatisticsView()
                        .padding()
                }
            default:
                ProgressView()
            }
        }
        .font(.system(size: 30))
        .animation(.default, value: kodi.state)
    }
}
