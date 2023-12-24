//
//  SettingsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI `View` for the main navigation (shared)
struct SettingsView: View {
    /// Bool for the confirmation dialog
    @State private var isPresentingConfirmReloadLibrary: Bool = false
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        ContentView.Wrapper(
            header: {
                PartsView.DetailHeader(
                    title: "Komodio Settings",
                    subtitle: nil
                )
            },
            content: {
                content
            },
            buttons: { }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        ScrollView {
            #if os(macOS)
            Text("Komodio Settings")
                .font(.largeTitle)
                .padding()
            #endif
            HStack {
                Grid(
                    alignment: .trailingFirstTextBaseline,
                    horizontalSpacing: 20,
                    verticalSpacing: 20
                ) {
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    GridRow {
                        Text("My Kodi's")
                            .font(StaticSetting.platform == .macOS ? .title : .title2)
                            .gridColumnAlignment(.trailing)
                        configuredHosts
                            .gridColumnAlignment(.leading)
                    }
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    newHosts
                }

#if !os(macOS)
                KodiHostItemView.KodiSettings()
                    .backport.focusable()
#endif
            }
        }
        .padding()
        .buttonStyle(.playButton)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


    // MARK: Configured hosts

    /// The configured hosts
    @ViewBuilder var configuredHosts: some View {
        if let hosts = Hosts.getConfiguredHosts() {
            VStack(alignment: .leading) {
                ForEach(hosts) { host in
                    Button(
                        action: {
#if os(macOS)
                            scene.detailSelection = .hostItemSettings(host: host)
#else
                            scene.navigationStack.append(.hostItemSettings(host: host))
#endif
                        }, label: {
                            Buttons.formatButtonLabel(
                                title: host.name,
                                subtitle: host.isOnline ? "Online" : "Offline",
                                icon: "globe",
                                color: host.isOnline ? host.isSelected ? .green : Color("AccentColor") : .red
                            )
                        }
                    )
                    if host.isSelected {
                        if kodi.status == .offline {
                            KodiHostItemView.HostIsOffline()
                        } else {
                            buttons
                                .scaleEffect(0.8)
                        }
                    }
                }
            }
        } else {
            KodiHostItemView.NoHostSelected()
        }
    }

    // MARK: Actions for the selected hosts

    /// Actions for the selected Kodi
    var buttons: some View {
        VStack(alignment: .leading) {
            Button(action: {
                isPresentingConfirmReloadLibrary = true
            }, label: {
                Buttons.formatButtonLabel(
                    title: "Reload Library",
                    subtitle: "Reload '\(kodi.host.name)'",
                    icon: "arrow.triangle.2.circlepath"
                )
            })
            .confirmationDialog(
                "Are you sure?",
                isPresented: $isPresentingConfirmReloadLibrary
            ) {
                Button("Reload the library") {
                    Task {
                        _ = scene.navigationStack.popLast()
                        await kodi.loadLibrary(cache: false)
                    }
                }
            } message: {
                Text("Reloading the library takes some time")
            }
            Button(
                action: {
#if os(macOS)
                    scene.detailSelection = .kodiSettings
#else
                    scene.navigationStack.append(.kodiSettings)
#endif
                }, label: {
                    Buttons.formatButtonLabel(
                        title: "Kodi Settings",
                        subtitle: "Settings on '\(kodi.host.name)'",
                        icon: "gear"
                    )
                }
            )
        }
        .padding(.bottom)
        .disabled(kodi.status != .loadedLibrary && kodi.status != .outdatedLibrary)
    }

    // MARK: New hosts

    /// The new hosts
    @ViewBuilder var newHosts: some View {
        if let newHosts = Hosts.getNewHosts() {
            GridRow {
                Text("New Kodi's")
                    .font(StaticSetting.platform == .macOS ? .title : .title2)
                VStack(alignment: .leading) {
                    ForEach(newHosts) { host in
                        Button(
                            action: {
#if os(macOS)
                                scene.detailSelection = .hostItemSettings(host: host)
#else
                                scene.navigationStack.append(.hostItemSettings(host: host))
#endif
                            }, label: {
                                Buttons.formatButtonLabel(
                                    title: host.name,
                                    subtitle: "\(host.ip)",
                                    icon: "star.fill",
                                    color: .orange
                                )
                            }
                        )
                    }
                }
            }
            Divider()
                .gridCellUnsizedAxes(.horizontal)
        }
    }
}
