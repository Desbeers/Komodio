//
//  PartsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of loose SwiftUI Views (shared)
enum PartsView {
    /// Just a namespace here...
}

extension PartsView {

    /// The header for details
    struct DetailHeader: View {
        /// The title of the message
        let title: String
        /// The optional subtitle
        var subtitle: String?

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                Text(title)
                    .font(.system(size: KomodioApp.platform == .macOS ? 40 : 60))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                /// Keep the height of the View, also when the text is scaled
                    .frame(height: KomodioApp.platform == .macOS ? 60 : 80)
                if let subtitle {
                    /// Init the text, because then we can use Mardown formatting
                    Text(.init(subtitle))
                        .font(.system(size: KomodioApp.platform == .macOS ? 20 : 40))
                        .opacity(0.6)
                }
            }
            .padding(.bottom)
        }
    }
}

extension PartsView {

    /// The message to show when a router item is empty, loading or Kodi is offline
    struct StatusMessage: View {
        /// The Router item
        let item: Router
        /// The status
        let status: Parts.Status

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                switch status {
                case .offline:
                    Text(status.offlineMessage)
                case .loading:
                    Text(item.loading)
                case .empty:
                    Text(item.empty)
                default:
                    EmptyView()
                }
            }
            .font(KomodioApp.platform == .macOS ? .title2 : .title3)
            .frame(maxHeight: .infinity)
        }
    }
}

extension PartsView {

    /// Overlay a View with a animated gradient
    struct GradientOverlay: View {
        /// The start of the animation
        @State var start = UnitPoint(x: 0, y: -2)
        /// The end of the animation
        @State var end = UnitPoint(x: 4, y: 0)
        /// Set a timer
        let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
        /// The colors for the gradient
        let colors = [
            Color(#colorLiteral(red: 0.337254902, green: 0.1137254902, blue: 0.7490196078, alpha: 1)),
            Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)),
            Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
            Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
            Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))
        ]

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
                .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: start)
                .onReceive(timer, perform: { _ in
                    self.start = UnitPoint(x: 4, y: 0)
                    self.end = UnitPoint(x: 0, y: 2)
                })
                .blendMode(.color)
        }
    }
}

extension PartsView {

    /// View a  icon image that can rotate
    struct RotatingIcon: View {
        /// The RotatingAnimationModel
        @StateObject var rotateModel = RotatingIconModel()
        /// Do we want to rotate or not
        @Binding var rotate: Bool

        // MARK: Body of the View

        /// The body of the View
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
            .animation(rotateModel.rotating ? rotateModel.foreverAnimation : .linear(duration: 0), value: rotateModel.rotating)
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

    /// Show text with optional 'more' button
    struct TextMore: View {
        /// The media item to show
        let item: any KodiItem
        /// Bool if we show the full text in a sheet
        @State private var showFullText: Bool = false
        /// The body of the View
        var body: some View {
            ViewThatFits(in: .vertical) {
                Text(item.description)
                VStack {
                    Text(item.description)
                    Button("More…") {
                        showFullText = true
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .focusSection()

#if os(macOS)
                    .font(.body)
#endif

#if os(tvOS)
                    .buttonStyle(.plain)
#endif

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

#if os(macOS)
                    .padding(60)
                    .background(alignment: .bottom) {
                        Button(action: {
                            showFullText = false
                        }, label: {
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
    struct SortLabel: View {
        let item: any KodiItem
        let sorting: SwiftlyKodiAPI.List.Sort
        var body: some View {
            switch sorting.method {
            case .dateAdded:
                Label(item.swiftDateFromKodiDate(item.dateAdded)
                    .formatted(date: KomodioApp.platform == .macOS ? .long : .abbreviated, time: .omitted),
                      systemImage: "plus.square"
                )
            case .rating:
                PartsView.ratingToStars(rating: Int(item.rating.rounded()))
            case .userRating:
                PartsView.ratingToStars(rating: item.userRating)
            case .duration:
                Label(Parts.secondsToTime(seconds: item.duration), systemImage: "clock")
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
