//
//  StartView+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View when starting Komodio (tvOS)
struct StartView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The optional selected host
    @State var selectedHost: HostItem?

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        HStack {
            hosts
            VStack {
                DetailView()
                VStack {
                    if kodi.bonjourHosts.isEmpty {
                        KodiHostItemView.KodiSettings()
                            .minimumScaleFactor(0.2)
                    }
                }
                if kodi.state == .loadedLibrary {
                    StatisticsView()
                        /// Navigation buttons for the statistics does not work on tvOS
                        .disabled(true)
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.default, value: kodi.state)
        }
        .buttonStyle(.plain)
        .sheet(item: $selectedHost) { host in
            HStack {
                KodiHostView.Details(host: host)
                    .frame(width: 600)
                    .minimumScaleFactor(0.2)
                KodiHostView(host: host)
            }
        }
    }

    // MARK: Hosts View

    /// Host items
    var hosts: some View {
        VStack {
            Text("Your Kodi's")
                .foregroundColor(.secondary)
                .font(.headline)
            VStack {
                if !kodi.configuredHosts.isEmpty {
                    ForEach(kodi.configuredHosts.sorted { $0.isSelected && !$1.isSelected }) { host in
                        VStack(alignment: .leading) {
                            Button(action: {
                                selectedHost = host
                            }, label: {
                                Label(title: {
                                    VStack(alignment: .leading) {
                                        Text(host.name)
                                        Text(host.isOnline ? "Online" : "Offline")
                                            .font(.caption)
                                            .opacity(0.6)
                                            .padding(.bottom, 2)
                                    }
                                    .frame(width: 200, alignment: .leading)
                                }, icon: {
                                    Image(systemName: "globe")
                                        .foregroundColor(host.isSelected ? host.isOnline ? .green : .red : .gray)
                                })
                            })
                            if host.isSelected {
                                VStack {
                                    Divider()
                                        .frame(width: 340)
                                    if kodi.state == .offline {
                                        KodiHostItemView.HostIsOffline()
                                            .frame(width: 340, alignment: .leading)
                                    } else {
                                        buttons
                                    }
                                }
                                .opacity(0.8)
                            }
                        }
                    }
                } else {
                    KodiHostItemView.NoHostSelected()
                        .frame(width: 380, alignment: .center)
                }
            }
            .padding(.horizontal)
            .padding(20)
            .background(.thinMaterial)
            .cornerRadius(20)
            if !kodi.bonjourHosts.filter({$0.new}).isEmpty {
                Text("New Kodi's on your network")
                    .foregroundColor(.secondary)
                    .font(.headline)
                VStack {
                    ForEach(kodi.bonjourHosts.filter({$0.new}), id: \.ip) { host in
                        Button(action: {
                            selectedHost = HostItem(ip: host.ip, media: .video, status: .new)
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

    // MARK: SwiftUI Buttons

    /// Actions for the selected Kodi
    var buttons: some View {
        VStack(alignment: .leading) {
            Button(action: {
                Task {
                    await KodiConnector.shared.loadLibrary(cache: false)
                }
            }, label: {
                Label("Reload Library", systemImage: "arrow.triangle.2.circlepath")
            })
            Button(action: {
                Task {
                    scene.showSettings = true
                }
            }, label: {
                Label("Kodi Settings", systemImage: "gear")
            })
        }
        .disabled(kodi.state != .loadedLibrary)
        .padding(.leading)
    }
}
