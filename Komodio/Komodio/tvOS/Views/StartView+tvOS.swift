//
//  StartView+tvOS.swift
//  Komodio (tvOS)
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
    /// The body of the View
    var body: some View {
        HStack {
            hosts
            VStack {
                StartView.Details()
                if kodi.state == .loadedLibrary {
                    StatisticsView()
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.default, value: kodi.state)
        }
        .buttonStyle(.plain)
    }
    /// Host items
    var hosts: some View {
        VStack(alignment: .leading) {
            Text("Your Kodi's")
                .font(.headline)
            ForEach(kodi.bonjourHosts, id: \.ip) { host in
                VStack(alignment: .leading) {
                    Button(action: {
                        if AppState.shared.host?.ip != host.ip {
                            var values = HostItem()
                            values.ip = host.ip
                            AppState.saveHost(host: values)
                        }
                    }, label: {
                        Label(title: {
                            Text(host.name)
                                .frame(width: 200)
                        }, icon: {
                            Image(systemName: "globe")
                                .foregroundColor(AppState.shared.host?.ip == host.ip ? .green : .gray)
                        })
                    })
                    if AppState.shared.host?.ip == host.ip {
                        VStack {
                            Divider()
                                .frame(width: 340)
                            buttons
                        }
                        .opacity(0.6)
                    }
                }
                .padding(.horizontal)
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(20)
            }
        }
        /// Move it away from the sidebar
        .padding(.leading, 180)
        .frame(width: 800)
    }

    // Actions for the selected Kodi
    var buttons: some View {
        VStack {
            Button(action: {
                Task {
                    scene.mainSelection = 0
                    scene.navigationSubtitle = ""
                    await KodiConnector.shared.loadLibrary(cache: false)
                }
            }, label: {
                Label("Reload Library", systemImage: "arrow.triangle.2.circlepath")
            })
            .disabled(kodi.state != .loadedLibrary)
            Button(action: {
                Task {
                    scene.showSettings = true
                }
            }, label: {
                Label("Kodi Settings", systemImage: "gear")
            })
            .disabled(kodi.state != .loadedLibrary)
        }
        .padding(.leading)
    }
}
