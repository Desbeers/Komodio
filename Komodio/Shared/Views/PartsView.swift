//
//  PartsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import SwiftlyRotatingView

// MARK: Parts View

/// Collection of loose SwiftUI Views (shared)
enum PartsView {
    /// Just a namespace here...
}

extension PartsView {

    // MARK: Parts Detail Header

    /// The header for details
    struct DetailHeader: View {
        /// The color scheme
        @Environment(\.colorScheme) var colorScheme
        /// The title of the header
        let title: String
        /// The optional subtitle
        var subtitle: String?
        /// The font size
        private var font: Double {
            switch StaticSetting.platform {
            case .macOS:
                return 30
            case .tvOS:
                return 60
            case .iPadOS:
                return 35
            }
        }
        /// The colors
        private var colors: [Color] {
            switch colorScheme {
                /// tvOS does not always respect the accentColor setting
            case .light:
                return [Color("AccentColor"), .black]
            case .dark:
                return [.white, Color("AccentColor")]
            @unknown default:
                return [Color("AccentColor"), .black]
            }
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            VStack {
                Text(title)
                    .font(.system(size: font))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if let subtitle {
                    /// Init the text, because then we can use Mardown formatting
                    Text(.init(subtitle))
                        .font(.system(size: font / 2))
                        .opacity(0.6)
                }
            }
            .frame(height: font * 1.5)
            .foregroundColor(colorScheme == .light ? .white : .black)
            .padding(.all, font / 3)
            .frame(maxWidth: .infinity)
            .background(
                RadialGradient(
                    gradient: Gradient(
                        colors: colors
                    ),
                    center: .center,
                    startRadius: 0,
                    endRadius: StaticSetting.platform == .macOS ? 280 : 500
                )
                .saturation(0.4)
            )
            .cornerRadius(StaticSetting.cornerRadius)
        }
    }
}

extension PartsView {

    // MARK: Parts Rotating Icon

    /// View a  icon image that can rotate
    struct RotatingIcon: View {
        /// Do we want to rotate or not
        let rotate: Bool

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Image("RotatingIconBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: minSize(size: geometry) / 50)
                    RotatingView(speed: 5, rotate: rotate) {
                        Image("RotatingIconForeground")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                    }
                }
                /// Below is needed or else the View will not center
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center
                )
            }
        }

        /// The minimum size of the record
        /// - Parameter size: The `View` size
        /// - Returns: The minimum size as `Double`
        func minSize(size: GeometryProxy) -> Double {
            return size.size.width > size.size.height ? size.size.height : size.size.width
        }
    }
}

extension PartsView {

    // MARK: Parts Text More

    /// Show text with optional 'more' button
    struct TextMore: View {
        /// The media item to show
        let item: any KodiItem
        /// Bool if we show the full text in a sheet
        @State private var showFullText: Bool = false
        /// The body of the `View`
        var body: some View {
            ViewThatFits(in: .vertical) {
                Text(item.description)
                VStack {
                    Text(item.description)
                    Button(
                        action: {
                            showFullText = true
                        },
                        label: {
                            Label(
                                title: {
                                    Text("More")
                                },
                                icon: {
                                    Image(systemName: "info.circle.fill")
                                }
                            )
                        }
                    )
                    .labelStyle(.playLabel)
                    .buttonStyle(.playButton)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .backport.focusSection()
                }
            }
            .sheet(isPresented: $showFullText) {
                VStack {
                    Text(item.title)
                        .font(.title)
                    Text(item.details)
                        .font(.subheadline)
                        .padding(.bottom)
                    Text(item.description)
                }

#if os(macOS) || os(visionOS)
                .padding(60)
                .background(alignment: .bottom) {
                    Button(
                        action: {
                            showFullText = false
                        },
                        label: {
                            Text("Close")
                        })
                    .padding()
                }
                .frame(width: 600)
#endif
            }
        }
    }
}

extension PartsView {

    // MARK: Parts Rating to Stars

    /// View a KodiItem rating rating with stars
    /// - Parameters:
    ///   - rating: The rating
    /// - Returns: A view with stars
    static func ratingToStars(rating: Int) -> some View {
        return HStack(spacing: 0) {
            ForEach(1..<6, id: \.self) { number in
                Image(systemName: image(number: number))
                    .foregroundColor(number * 2 <= rating + 1 ? .yellow : .secondary.opacity(0.4))
                    .fontWeight(.bold)
            }
        }

        /// Convert a number to an SF image String
        /// - Parameter number: The number
        /// - Returns: The SF image as String
        func image(number: Int) -> String {
            if number * 2 <= rating {
                return "star.fill"
            } else if number * 2 == rating + 1 {
                return "star.leadinghalf.filled"
            } else {
                return "star"
            }
        }
    }
}
