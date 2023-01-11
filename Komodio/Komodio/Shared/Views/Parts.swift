//
//  Parts.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of loose parts
enum Parts {
    /// Just a namespace here...
}

extension Parts {

    /// Convert 'seconds' to a formatted string
    /// - Parameters:
    ///   - seconds: The seconds
    ///   - style: The time format
    /// - Returns: A formatted String
    static func secondsToTime(seconds: Int, style: DateComponentsFormatter.UnitsStyle = .brief) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        return formatter.string(from: TimeInterval(Double(seconds)))!
    }
}

extension Parts {

    /// The message to show in ``DetailView``
    struct DetailMessage: View {
        /// The title of the message
        let title: String
        /// The optional message
        var message: String?

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                if let message {
                    Text(.init(message))
                        .font(.system(size: 20))
                        .opacity(0.6)
                        .padding(.bottom)
                }
            }
        }
    }
}

extension Parts {

    /// The state of  loading a View
    enum Status {
        /// The Task is loading the items
        case loading
        /// No items where found by the `Task`
        case empty
        /// The `Task` is done and items where found
        case ready
        /// The host is offline
        case offline
        /// The message when offline
        var offlineMessage: Text {
            Text("Komodio is not connected to a host")
        }
    }
}

extension Parts {

    /// Filter for media lists
    enum Filter {
        /// Do not filter
        case none
        /// Filter for unwatched media
        case unwatched
    }
}

extension Parts {

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

extension Parts {

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
        /// - Returns: The minimum size as `CGFloat`
        func minSize(size: GeometryProxy) -> CGFloat {
            return size.size.width > size.size.height ? size.size.height : size.size.width
        }
    }
}
