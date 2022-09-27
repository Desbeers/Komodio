//
//  SettingsView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Settings' SwiftUI View
struct SettingsView: View {
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text("Maintanance")
                    .font(.title2)
                Form {
                    Button(action: {
                        Task {
                            appState.selectedTab = .home
                            await KodiConnector.shared.loadLibrary(cache: false)
                        }
                    }, label: {
                        Text("Reload library")
                    })
                    .disabled(kodi.state != .loadedLibrary)
                }
            }
            Divider()
            VStack {
                Text("Your Kodi host")
                    .font(.title2)
                if kodi.bonjourHosts.isEmpty {
                    Text("There are no Kodi's online")
                }
                HostView()
                    .frame(width: 900)
            }
        }
    }
}
