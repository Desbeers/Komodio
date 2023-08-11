//
//  StartView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Start View

/// SwiftUI `View` when starting Komodio (shared)
struct StartView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// Bool for the confirmation dialog
    @State private var isPresentingConfirmReloadLibrary: Bool = false
    /// The opacity of the View
    /// - The View will have a delay to give Komodio some time to load a library
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        content
            .opacity(opacity)
            .animation(.default, value: opacity)
            .task {
                if kodi.status == .loadedLibrary {
                    opacity = 1
                } else {
                    /// Give Komodio some time to connect to a host
                    Task {
                        try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                        opacity = 1
                    }
                }
            }
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        HStack {
#if os(tvOS) || os(iOS)
            StartView.Details()
                .padding(.leading, KomodioApp.sidebarCollapsedWidth)
#endif
            ScrollView {
                VStack {
                    configuredHosts
                    newHosts
                }
                .buttonStyle(.playButton)
                .labelStyle(.playLabel)
                .padding()
                .animation(.default, value: kodi.status)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: Configured hosts

    /// The configured hosts
    @ViewBuilder var configuredHosts: some View {
        if let hosts = Hosts.getConfiguredHosts() {
            Text("Your Kodi's")
                .font(.title)
            Divider()
            ForEach(hosts) { host in

                NavigationLink(value: Router.hostItemSettings(host: host)) {
                    Buttons.formatButtonLabel(
                        title: host.name,
                        subtitle: host.isOnline ? "Online" : "Offline",
                        icon: "globe",
                        color: host.isOnline ? host.isSelected ? .green : Color("AccentColor") : .red
                    )
                }
                if host.isSelected {
                    if kodi.status == .offline {
                        KodiHostItemView.HostIsOffline()
                    } else {
                        buttons
                            .opacity(0.8)
                    }
                }
                Divider()
            }
        } else {
            KodiHostItemView.NoHostSelected()
        }
    }

    // MARK: New hosts

    /// The new hosts
    @ViewBuilder var newHosts: some View {
        if let newHosts = Hosts.getNewHosts() {
            Text("New Kodi's")
                .font(.title)
            ForEach(newHosts) { host in
                NavigationLink(value: Router.hostItemSettings(host: host)) {
                    Label(title: {
                        Text(host.name)
                    }, icon: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    })
                }
            }
        }
    }

    // MARK: Actions for the selected hosts

    /// Actions for the selected Kodi
    var buttons: some View {
        VStack {
            if kodi.status == .loadedLibrary {
                StatisticsView()
                    .frame(maxHeight: .infinity)
            }
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
                        await kodi.loadLibrary(cache: false)
                    }
                }
            } message: {
                Text("Reloading the library takes some time")
            }
            NavigationLink(value: Router.kodiSettings) {
                Buttons.formatButtonLabel(
                    title: "Kodi Settings",
                    subtitle: "Settings on '\(kodi.host.name)'",
                    icon: "gear"
                )
            }
        }
        .padding(.bottom)
        .disabled(kodi.status != .loadedLibrary && kodi.status != .outdatedLibrary)
        .buttonStyle(.playButton)
    }
}
