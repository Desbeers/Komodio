//
//  StartView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Start' SwiftUI View
struct StartView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The body of this View
    var body: some View {
        VStack {
            switch kodi.state {
            case .offline:
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("'\(appState.host?.description ?? "")' is offline")
                            .font(.title)
                        Text(kodi.bonjourHosts.isEmpty ? "There are no Kodi's online" : "Please select another Kodi host")
                            .font(.subheadline)
                    }
                }, icon: {
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                HostView()
            case .none:
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("Welcome to Komodio!")
                            .font(.title)
                        Text(kodi.bonjourHosts.isEmpty ? "There are no Kodi's online" : "Please select your Kodi host")
                            .font(.subheadline)
                    }
                }, icon: {
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                HostView()
            case .loadedLibrary:
                HomeView()
            default:
                VStack {
                    ProgressView()
                        .padding()
                    Text("Loading your library...")
                }
            }
        }
    }
}
