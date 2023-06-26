//
//  StartView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Start View

/// SwiftUI View when starting Komodio (shared)
struct StartView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The opacity of the View
    /// - The View will have a delay to give Komodio some time to load a library
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        Content()
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
}

extension StartView {

    // MARK: Start Content

    /// SwiftUI View when starting Komodio (macOS)
    struct Content: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// Bool for the confirmation dialog
        @State private var isPresentingConfirmReloadLibrary: Bool = false

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
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
#if os(tvOS) || os(iOS)
                StartView.Details()
#endif
            }
        }

        /// The configured hosts
        @ViewBuilder var configuredHosts: some View {
            if let hosts = Hosts.getConfiguredHosts() {
                Text("Your Kodi's")
                    .font(.title)
                Divider()
                ForEach(hosts) { host in

                    NavigationLink(value: host) {
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
                    .frame(width: 380, alignment: .center)
            }
        }

        /// The new hosts
        @ViewBuilder var newHosts: some View {
            if let newHosts = Hosts.getNewHosts() {
                Text("New Kodi's")
                    .font(.title)
                ForEach(newHosts) { host in
                    NavigationLink(value: host) {
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

        // MARK: Actions for the selected Kodi

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
                            await KodiConnector.shared.loadLibrary(cache: false)
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
}

extension StartView {

    // MARK: Start Details

    /// SwiftUI View with details of the StartView
    struct Details: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// Rotate the record
        @State private var rotate: Bool = false

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                PartsView.DetailHeader(title: kodi.host.name, subtitle: kodi.status.message)
                PartsView.RotatingIcon(rotate: $rotate)
                    .task(id: kodi.status) {
                        rotate = kodi.status == .loadedLibrary ? true : false
                    }
                if kodi.status != .loadedLibrary {
                    HStack {
                        ProgressView()
                            .padding(.trailing)
                        Text(kodi.status.message)
                    }
                    .font(.headline)
                    .padding()
                }
            }
            .animation(.default, value: kodi.status)
        }
    }
}
