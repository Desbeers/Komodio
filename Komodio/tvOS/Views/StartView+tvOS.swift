//
//  StartView+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension StartView {

    // MARK: Start Content

    /// SwiftUI View when starting Komodio (tvOS)
    struct Content: View {
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The optional selected host
        @State var selectedHost: HostItem?

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            ContentWrapper(
                scroll: false,
                header: {
                    PartsView.DetailHeader(title: kodi.host.bonjour?.name ?? "Komodio", subtitle: kodi.status.message)
                }, content: {
                    HStack {
                        hosts
                            .frame(maxHeight: .infinity, alignment: .top)
                        VStack {
                            DetailView()
                            VStack {
                                if kodi.bonjourHosts.isEmpty {
                                    KodiHostItemView.KodiSettings()
                                        .minimumScaleFactor(0.2)
                                }
                            }
                            if kodi.status == .loadedLibrary {
                                StatisticsView()
                                    .transition(.move(edge: .trailing))
                                    .padding(.bottom)
                            }
                        }
                        .animation(.default, value: kodi.status)
                    }
                }
            )
            .sheet(item: $selectedHost) { host in
                HStack {
                    HostItemView.KodiSettings()
                        .frame(width: 600)
                        .minimumScaleFactor(0.2)
                    HostItemView(host: host)
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
                    if let hosts = Hosts.getConfiguredHosts() {
                        ForEach(hosts) { host in
                            VStack {
                                Button(action: {
                                    selectedHost = host
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
                                    }, icon: {
                                        Image(systemName: "globe")
                                            .foregroundColor(
                                                host.isOnline ? host.isSelected ? .green : Color("AccentColor") : .red
                                            )
                                    })
                                })
                                if host.isSelected {
                                    VStack {
                                        Divider()
                                            .frame(width: 340)
                                        if kodi.status == .offline {
                                            KodiHostItemView.HostIsOffline()
                                                .frame(width: 340, alignment: .leading)
                                        } else {
                                            buttons
                                                .scaleEffect(0.8)
                                        }
                                        Divider()
                                            .frame(width: 340)
                                    }
                                    .opacity(0.8)
                                    .animation(.default, value: kodi.status)
                                }
                            }
                        }
                    } else {
                        KodiHostItemView.NoHostSelected()
                            .padding(.bottom)
                            .frame(width: 380, alignment: .center)
                    }
                }
                if let newHosts = Hosts.getNewHosts() {
                    Text("New Kodi's")
                        .foregroundColor(.secondary)
                        .font(.headline)
                    VStack {
                        ForEach(newHosts) { host in
                            Button(action: {
                                selectedHost = host
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
            }
            .padding(40)
            .background(.thinMaterial)
            .cornerRadius(20)
            .buttonStyle(.plain)
            /// Move it away from the sidebar
            .padding(.leading, 180)
            .frame(width: 800)
        }

        // MARK: SwiftUI Buttons

        /// Actions for the selected Kodi
        @ViewBuilder var buttons: some View {
            if kodi.status == .loadedLibrary || kodi.status == .outdatedLibrary {
                VStack {
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
                .padding(.leading)
            } else {
                ProgressView()
                    .padding(.bottom)
            }
        }
    }
}
