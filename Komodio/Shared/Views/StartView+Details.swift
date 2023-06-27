//
//  StartView+Details.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
