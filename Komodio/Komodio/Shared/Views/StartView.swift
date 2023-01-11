//
//  StartView.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
                Parts.DetailMessage(title: kodi.state.rawValue)
                    .padding(.top, 40)
                Parts.RotatingIcon(rotate: $rotate)
                    .task(id: kodi.state) {
                        rotate = kodi.state == .loadedLibrary ? true : false
                    }
            }
        }
    }
}
