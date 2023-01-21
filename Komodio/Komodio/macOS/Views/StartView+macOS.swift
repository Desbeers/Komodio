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
    @EnvironmentObject private var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    var body: some View {
        VStack {
            Parts.DetailMessage(title: kodi.host.bonjour?.name ?? "")
                .padding(.top, 40)
            VStack {
                switch kodi.state {
                case .loadedLibrary:
                    VStack(alignment: .center) {
                        StatisticsView.HostInfo()
                        StatisticsView()
                    }
                case .loadingLibrary:
                    ProgressView()
                case .offline:
                    KodiHostItemView.HostIsOffline()
                    KodiHostItemView.KodiSettings()
                case .none:
                    KodiHostItemView.NoHostSelected()
                    KodiHostItemView.KodiSettings()
                default:
                    EmptyView()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.leading)
        }
        .animation(.default, value: kodi.state)
    }
}
