//
//  StartView+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View when starting Komodio  (macOS)
struct StartView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            Parts.DetailMessage(title: appState.host?.description ?? "")
                .padding(.top, 40)
            switch kodi.state {
            case .loadedLibrary:
                VStack(alignment: .center) {
                    StatisticsView.HostInfo()
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 20)

                    StatisticsView()
                        .padding()
                }
            default:
                ProgressView()
            }
        }
        .animation(.default, value: kodi.state)
    }
}
