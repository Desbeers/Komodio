//
//  SiriRemoteController.swift
//  Komodio (tvOS)
//
//  © 2024 Nick Berendsen
//
// https://developer.apple.com/forums/thread/25440
// https://stackoverflow.com/questions/59250277/detect-siri-remote-swipe-in-swiftui

import SwiftUI
import GameController
import AVFoundation

// MARK: Siri Remote Controller

/// Class to observe the Siri remote (tvOS)
@Observable class SiriRemoteController {
    /// The list of controllers
    var controllerList: [GCController] = []
    /// The controller that is found
    var gameController: GCController?
    /// Init the controller -- this assume only Siri Remote is connected
    init() {
        getControllers()
    }
    /// Deinit the controller
    deinit {
        NotificationCenter
            .default
            .removeObserver(self, name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter
            .default
            .removeObserver(self, name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
    /// Get the controllers
    func getControllers() {
        controllerList = GCController.controllers()
        if controllerList.count < 1 {
            /// No controller; try and attach to them
            attachControllers()
        }
    }
    /// Attach the controllers
    func attachControllers() {
        registerForGameControllerNotifications()
        /// Basic call to get game controllers
        GCController.startWirelessControllerDiscovery()
    }
    /// Setup notification when Controller is found
    func registerForGameControllerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleControllerDidConnectNotification(notification: )),
            name: NSNotification.Name.GCControllerDidConnect,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleControllerDidDisconnectNotification(notification: )),
            name: NSNotification.Name.GCControllerDidDisconnect,
            object: nil
        )
    }
    /// Notification when Controller is connected
    @objc func handleControllerDidConnectNotification(notification: NSNotification) {
        /// Assign the gameController which is found
        /// - Note: This will break if more than 1 if found
        gameController = notification.object as? GCController
    }
    /// Notification when Controller is disconnected
    @objc func handleControllerDidDisconnectNotification(notification: NSNotification) {
        /// if a controller disconnects we should see it
        print("\(#function)")
    }
}

extension SiriRemoteController {

    // MARK: PlayNavigation Sound

    /// Play the navigation sound when navigating the main menu
    static func playNavigationSound() {
        /// I can't find the proper ID of this sound so I use the URL instead...
        var systemSoundID: SystemSoundID = 1
        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/focus_change_large.caf")
        AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
        AudioServicesPlaySystemSound(systemSoundID)
    }
}

extension Modifiers {

    // MARK: SwipeGestureActions Modifier

    /// SwiftUI `View` Modifier for a swipe gesture
    struct SwipeGestureActions: ViewModifier {
        /// The closures to execute when up gesture is detected
        var onUp: () -> Void = {}
        /// The closures to execute when down gesture is detected
        var onDown: () -> Void = {}
        /// The closures to execute when right gesture is detected
        var onRight: () -> Void = {}
        /// The closures to execute when left gesture is detected
        var onLeft: () -> Void = {}

        // MARK: Private stuff

        /// The shared controller class
        @State private var controller: SiriRemoteController = SiriRemoteController()
        /// swipeDistance is how much x/y values needs to be acumelated by a gesture in order to consider a swipe (the distance the finger must travel)
        private let swipeDistance: Float = 0.7
        /// How much pause in milliseconds should be between gestures in order for a gesture to be considered a new gesture
        /// and not a remenat x/y values from the previous gesture
        private let secondsBetweenInteractions: Double = 0.2
        /// The last 'Y' position
        @State private var lastY: Float = 0
        /// The last 'X' position
        @State private var lastX: Float = 0
        /// The total 'Y' distance
        @State private var totalYSwipeDistance: Float = 0
        /// The total 'X' distance
        @State private var totalXSwipeDistance: Float = 0
        /// The 'timeinterval' of the last swipe
        @State private var lastInteractionTimeInterval: TimeInterval = Date().timeIntervalSince1970
        /// Bool if the swipe is new or not
        @State private var isNewSwipe: Bool = true

        // swiftlint:disable identifier_name

        /// The body of the `ViewModifier`
        func body(content: Content) -> some View {
            content
                .task(id: controller.gameController) {
                    /// Make sure we have a Siri remote
                    if let microGamepad = controller.gameController?.microGamepad {
                        /// Assumes the location where the user first touches the pad is the origin value (0.0,0.0)
                        microGamepad.reportsAbsoluteDpadValues = false
                        let currentHandler = microGamepad.dpad.valueChangedHandler
                        microGamepad.dpad.valueChangedHandler = { pad, x, y in
                            /// if there is already a hendler set - execute it as well
                            if let currentHandler {
                                currentHandler(pad, x, y)
                            }
                            /// check how much time passed since the last interaction on the siri remote,
                            /// If enough time has passed - reset counters and consider these coming values as a new gesture values
                            let nowTimestamp = Date().timeIntervalSince1970
                            let elapsedNanoSinceLastInteraction = nowTimestamp - lastInteractionTimeInterval
                            lastInteractionTimeInterval = nowTimestamp // update the last interaction interval
                            if elapsedNanoSinceLastInteraction > secondsBetweenInteractions {
                                resetCounters(x: x, y: y)
                            }
                            /// accumelate the Y axis swipe travel distance
                            let currentYSwipeDistance = y - lastY
                            lastY = y
                            totalYSwipeDistance += currentYSwipeDistance
                            /// accumelate the X axis swipe travel distance
                            let currentXSwipeDistance = x - lastX
                            lastX = x
                            totalXSwipeDistance += currentXSwipeDistance
                            /// check if swipe travel goal has been reached in one of the directions (up/down/left/right)
                            /// as long as it is consedered a new swipe (and not a swipe that was already detected and executed
                            /// and waiting for a few milliseconds stop between interactions)
                            if isNewSwipe {
                                if totalYSwipeDistance > swipeDistance && totalYSwipeDistance > 0 {
                                    /// Swipe up detected
                                    /// Lock so next values will be disregarded until a few milliseconds of 'remote silence' achieved
                                    isNewSwipe = false
                                    /// Execute the appropriate closure for this detected swipe
                                    onUp()
                                } else if totalYSwipeDistance < -swipeDistance && totalYSwipeDistance < 0 {
                                    /// Swipe down detected
                                    isNewSwipe = false
                                    onDown()
                                } else if totalXSwipeDistance > swipeDistance && totalXSwipeDistance > 0 {
                                    /// Swipe right detected
                                    isNewSwipe = false
                                    onRight()
                                } else if totalXSwipeDistance < -swipeDistance && totalXSwipeDistance < 0 {
                                    /// Swipe left detected
                                    isNewSwipe = false
                                    onLeft()
                                }
                            }
                        }
                    }
                }
        }

        /// Reset the swipe counters
        /// - Parameters:
        ///   - x: The current 'X' position
        ///   - y: The current 'Y' position
        private func resetCounters(x: Float, y: Float) {
            isNewSwipe = true
            /// Start counting from the 'Y' point the finger is touching
            lastY = y
            totalYSwipeDistance = 0
            /// start counting from the 'X' point the finger is touching
            lastX = x
            totalXSwipeDistance = 0
        }
        // swiftlint:enable identifier_name
    }
}

extension View {

    /// Shortcut to ``Modifiers/SwipeGestureActions``
    /// - Parameters:
    ///   - onUp: The closures to execute when up gesture is detected
    ///   - onDown: The closures to execute when down gesture is detected
    ///   - onRight: The closures to execute when right gesture is detected
    ///   - onLeft: The closures to execute when left gesture is detected
    /// - Returns: A modified View
    func swipeGestures(
        onUp: @escaping () -> Void = {},
        onDown: @escaping () -> Void = {},
        onRight: @escaping () -> Void = {},
        onLeft: @escaping () -> Void = {}
    ) -> some View {
        self
        /// The GameController does not work in the simulator; use the arrow keys instead
            .onMoveCommand { direction in
                switch direction {
                case .up:
                    onUp()
                case .down:
                    onDown()
                case .left:
                    onLeft()
                case .right:
                    onRight()
                @unknown default:
                    break
                }
            }
            .modifier(Modifiers.SwipeGestureActions(
                onUp: onUp,
                onDown: onDown,
                onRight: onRight,
                onLeft: onLeft)
            )
    }
}

extension Modifiers {

    // MARK: Siri Exit Modifier

    /// A `ViewModifier` to control the Siri Exit button
    struct SetSiriExit: ViewModifier {
        /// The SceneState model
        @Environment(SceneState.self) private var scene
        /// The modifier
        func body(content: Content) -> some View {
            content
                .animation(.default, value: scene.navigationStack)
                .onExitCommand {
                    if scene.navigationStack.isEmpty {
                        scene.toggleSidebar.toggle()
                    } else {
                        scene.navigationStack.removeLast()
                    }
                }
        }
    }
}

extension View {

    /// A `ViewModifier` to control the Siri Exit button
    func setSiriExit() -> some View {
        modifier(Modifiers.SetSiriExit())
    }
}
