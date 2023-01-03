//
//  Parts.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI

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
        let title: String
        let message: String
        var body: some View {
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                Text(.init(message))
                    .font(.system(size: 20))
                    .opacity(0.6)
                    .padding(.bottom)
            }
        }
    }
}

extension Parts {

    /// The state of  loading a View
    enum State {
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
        case none
        case unwatched
    }
}

extension Parts {

    /// View a  record image that can rotate
    struct RotatingIcon: View {
        /// The RotatingAnimationModel
        @StateObject var rotateModel = RotatingIconModel()
        /// Do we want to rotate or not
        @Binding var rotate: Bool
        /// The body of the `View`
        var body: some View {
            GeometryReader { geometry in
                    Image("Huge Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .shadow(radius: minSize(size: geometry) / 50)
                /// Below is needed or else the View will not center
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center
                )

                /// The custom rotator
                .modifier(RotatingIconModel.Rotate(rotate: rotateModel.rotating, status: $rotateModel.status))
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
