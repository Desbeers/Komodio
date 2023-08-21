//
//  PartsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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

    // MARK: Parts Status Message

    /// The message to show when a router item is empty, loading or Kodi is offline
    struct StatusMessage: View {
        /// The Router item
        let router: Router
        /// The status
        let status: Parts.Status

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            VStack {
                switch status {
                case .offline:
                    Text(status.offlineMessage)
                case .empty:
                    Text(router.item.empty)
                default:
                    EmptyView()
                }
            }
            .font(StaticSetting.platform == .macOS ? .title2 : .title3)
            .frame(maxHeight: .infinity)
        }
    }
}

extension PartsView {

    // MARK: Parts Rotating Icon

    /// View a  icon image that can rotate
    struct RotatingIcon: View {
        /// The RotatingAnimationModel
        @StateObject var rotateModel = RotatingIconModel()
        /// Do we want to rotate or not
        @Binding var rotate: Bool

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Image("RotatingIconBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: minSize(size: geometry) / 50)
                    Image("RotatingIconForeground")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                    /// The custom rotator
                        .modifier(RotatingIconModel.Rotate(rotate: rotateModel.rotating, status: $rotateModel.status))
                }
                /// Below is needed or else the View will not center
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center
                )
            }
            .animation(
                rotateModel.rotating ? rotateModel.foreverAnimation : .linear(duration: 0),
                value: rotateModel.rotating
            )
            .task(id: rotate) {
                switch rotate {
                case true:
                    /// Start the rotation
                    /// - Note: It will start with some delay to make it more smoother
                    await rotateModel.startRotating()
                case false:
                    /// Tell the model we like to stop
                    /// - Note: It will be stopped when the animation is completed
                    rotateModel.stopRotating()
                }
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

extension PartsView {

    // MARK: Parts Sort Label

    /// SwiftUI `View` for a sorting label
    struct SortLabel: View {
        /// The KodiItem
        let item: any KodiItem
        /// The sort method
        let sorting: SwiftlyKodiAPI.List.Sort

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            switch sorting.method {
            case .dateAdded:
                Label(
                    Utils.swiftDateFromKodiDate(item.dateAdded)
                        .formatted(date: StaticSetting.platform == .macOS ? .long : .abbreviated, time: .omitted),
                    systemImage: "plus.square"
                )
            case .rating:
                PartsView.ratingToStars(rating: Int(item.rating.rounded()))
            case .userRating:
                PartsView.ratingToStars(rating: item.userRating)
            case .duration:
                Label(Utils.secondsToTimeString(seconds: item.duration), systemImage: "clock")
            case .year:
                Text(item.year.description)
            default:
                #if os(macOS)
                Text(item.year.description)
                #endif
                #if os(tvOS)
                EmptyView()
                #endif
            }
        }
    }
}
