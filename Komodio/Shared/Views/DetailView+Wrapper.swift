//
//  Detail+Wrapper.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Detail Wrapper

extension DetailView {

    /// SwiftUI View to wrap the ``DetailView``
    struct Wrapper<Content: View>: View {
        /// Wrap the view in a `ScrollView` or not
        let scroll: Bool
        /// View the details as part of another View
        var part: Bool = false
        /// The optional title of the message
        let title: String?
        /// The optional subtitle
        var subtitle: String?
        /// The content of the View
        @ViewBuilder var content: () -> Content

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            wrapper
                .frame(maxWidth: .infinity)
        }

        // MARK: Wrapper of the View

        /// The wrapper of the `View`
        @ViewBuilder var wrapper: some View {
            switch scroll {
            case true:
                scrollContent
            case false:
                fixedContent
            }
        }

        /// The header of the `View`
        @ViewBuilder var header: some View {
            if let title {
                switch part {
                case true:
                    VStack {
                        Text(title)
                            .font(.title)
                        if let subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                        }
                    }
                    .padding(.top)
                case false:
                    PartsView.DetailHeader(title: title, subtitle: subtitle)
                        .padding([.top, .horizontal])
                }
            }
        }

        /// The content in a `ScrollView`
        @ViewBuilder var scrollContent: some View {
            ScrollView {
                fixedContent
            }
        }

        /// The content in a `VStack`
        @ViewBuilder var fixedContent: some View {
            VStack(spacing: 0) {
                header
                content()
                    .padding()
            }
        }
    }
}
