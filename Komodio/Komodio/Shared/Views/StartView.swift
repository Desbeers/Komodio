//
//  StartView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View when starting Komodio
struct StartView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The opacity of the View
    /// - The View will have a delay to give Komodio some time to load a library
    @State private var opacity: Double = 0

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        Content()
            .opacity(opacity)
            .animation(.default, value: opacity)
            .task {
                if kodi.state == .loadedLibrary {
                    opacity = 1
                } else {
                    /// Give Komodio some time to connect to a host
                    Task {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        opacity = 1
                    }
                }
            }
    }
}

extension StartView {

    // MARK: Details of the View

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
                if kodi.state != .loadedLibrary {
                    Parts.DetailMessage(title: kodi.state.message)
                        .padding(.top, 40)
                }
                Parts.RotatingIcon(rotate: $rotate)
                    .task(id: kodi.state) {
                        rotate = kodi.state == .loadedLibrary ? true : false
                    }
            }
            .animation(.default, value: kodi.state)
        }
    }
}
