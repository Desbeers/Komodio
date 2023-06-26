//
//  DetailWrapper.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Detail Wrapper

/// SwiftUI View to wrap the ``DetailView``
struct DetailWrapper<Content: View>: View {

    /// The title of the message
    let title: String
    /// The optional subtitle
    var subtitle: String?
    /// The content of the View
    @ViewBuilder var content: () -> Content

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
#if os(macOS)
        ScrollView {
            PartsView.DetailHeader(title: title, subtitle: subtitle)
            content()
                .padding(.horizontal, 30)
        }
#endif

#if os(tvOS)
        VStack {
            Text(title)
                .font(.title2)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            content()
        }
        .padding(40)
#endif

#if os(iOS)
        ScrollView {
            PartsView.DetailHeader(title: title, subtitle: subtitle)
            content()
                .padding(.horizontal, 30)
        }
#endif
    }
}
