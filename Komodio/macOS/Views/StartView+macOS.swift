//
//  StartView+macOS.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension StartView {

    // MARK: Start Content

    /// SwiftUI View when starting Komodio (macOS)
    struct Content: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            ScrollView {
                VStack {
                    configuredHosts
                    newHosts
                }
                .buttonStyle(.playButton)
                .labelStyle(.playLabel)
                .padding()
                .animation(.default, value: kodi.status)
                .task {
                    scene.navigationSubtitle = ""
                }
            }
        }

        /// The configured hosts
        @ViewBuilder var configuredHosts: some View {
            if let hosts = Hosts.getConfiguredHosts() {
                Text("Your Kodi's")
                    .font(.title)
                Divider()
                ForEach(hosts) { host in
                    Button(action: {
                        scene.sidebarSelection = .hostItemSettings(host: host)
                    }, label: {
                        Label(title: {
                            VStack(alignment: .leading) {
                                Text(host.name)
                                if !host.isOnline {
                                    Text("Offline")
                                        .font(.caption)
                                        .opacity(0.6)
                                }
                            }
                            .frame(width: 200, alignment: .leading)
                        }, icon: {
                            Image(systemName: "globe")
                                .foregroundColor(
                                    host.isOnline ? host.isSelected ? .green : Color("AccentColor") : .red
                                )
                        })
                    })
                    if host.isSelected {
                        if kodi.status == .offline {
                            KodiHostItemView.HostIsOffline()
                        } else {
                            buttons
                                .opacity(0.8)
                            if kodi.status == .loadedLibrary {
                                StatisticsView()
                            } else {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                    Divider()
                }
            } else {
                KodiHostItemView.NoHostSelected()
                    .frame(width: 380, alignment: .center)
            }
        }

        /// The new hosts
        @ViewBuilder var newHosts: some View {
            if let newHosts = Hosts.getNewHosts() {
                Text("New Kodi's")
                    .font(.title)
                ForEach(newHosts) { host in
                    Button(
                        action: {
                            scene.sidebarSelection = .hostItemSettings(host: host)
                        }, label: {
                            Label(title: {
                                Text(host.name)
                                    .frame(width: 200, alignment: .leading)
                            }, icon: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            })
                        })
                }
            }
        }
        // MARK: SwiftUI Buttons

        /// Actions for the selected Kodi
        var buttons: some View {
            VStack(alignment: .leading) {
                Button(action: {
                    Task {
                        await KodiConnector.shared.loadLibrary(cache: false)
                    }
                }, label: {
                    Label(
                        title: {
                            Text("Reload Library")
                                .frame(width: 100, alignment: .leading)
                        }, icon: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        })
                })
                Button(action: {
                    Task {
                        scene.sidebarSelection = .kodiSettings
                    }
                }, label: {
                    Label(
                        title: {
                            Text("Kodi Settings")
                                .frame(width: 100, alignment: .leading)
                        }, icon: {
                            Image(systemName: "gear")
                        })
                })
            }
            .disabled(kodi.status != .loadedLibrary && kodi.status != .outdatedLibrary)
        }
    }
}
