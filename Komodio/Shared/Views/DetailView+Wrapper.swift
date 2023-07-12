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

    /// SwiftUI `View` to wrap the ``DetailView``
    struct Wrapper<Content: View>: View {
        /// Wrap the view in a `ScrollView` when set
        let scroll: String?
        /// View the details as part of another View
        var part: Bool = false
        /// The optional title of the message
        let title: String?
        /// The optional subtitle
        var subtitle: String?
        /// The content of the `View`
        @ViewBuilder var content: () -> Content

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            wrapper
            /// Use the full width
                .frame(maxWidth: .infinity)
            /// Set the font style
                .detailsFontStyle()
            /// Make the details focusable
                .backport.focusSection()
        }

        // MARK: Wrapper of the View

        /// The wrapper of the `View`
        @ViewBuilder var wrapper: some View {
            if scroll == nil {
                fixedContent
            } else {
                scrollContent
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
                ScrollViewReader { proxy in
                    fixedContent
                        .onChange(of: scroll) { _ in
                            withAnimation(.easeOut(duration: 1)) {
                                proxy.scrollTo(0, anchor: .top)
                            }
                        }
                }
            }
        }

        /// The content in a `VStack`
        @ViewBuilder var fixedContent: some View {
            VStack(spacing: 0) {
                header
                    .id(0)
                content()
                    .padding()
            }
        }
    }
}
