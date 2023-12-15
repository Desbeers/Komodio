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

    /// SwiftUI `View` with details of the StartView
    struct Details: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self) private var kodi
        /// Rotate the record
        @State private var rotate: Bool = false

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            DetailView.Wrapper(
                scroll: nil,
                part: StaticSetting.platform == .macOS ? false : true,
                title: kodi.host.name,
                subtitle: kodi.status.message
            ) {
                PartsView.RotatingIcon(rotate: rotate)
            }
            .animation(.default, value: kodi.status)
            .task(id: kodi.status) {
                rotate = kodi.status == .loadedLibrary ? true : false
            }
        }
    }
}
