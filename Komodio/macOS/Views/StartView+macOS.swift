//
//  StartView+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension StartView {

    // MARK: Content of the View

    /// SwiftUI View when starting Komodio (macOS)
    struct Content: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                PartsView.DetailMessage(title: kodi.host.bonjour?.name ?? "")
                    .padding(.top, 40)
                VStack {
                    switch kodi.status {
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
            .animation(.default, value: kodi.status)
        }
    }
}
