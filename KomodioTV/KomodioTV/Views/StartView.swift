//
//  StartView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 25/09/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct StartView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The AppState
    @EnvironmentObject var appState: AppState
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
