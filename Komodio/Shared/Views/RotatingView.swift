//
//  RotatingView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// A SwiftUI `View` that can rotate with a smooth start and stop
public struct RotatingView<Content: View>: View {
    /// Public init
    public init(speed: Double, rotate: Bool, @ViewBuilder content: () -> Content) {
        self.speed = speed
        self.rotate = rotate
        self.content = content()
    }
    /// The speed of the rotation
    let speed: Double
    /// Bool if the view should rotate
    let rotate: Bool
    /// The content of the `View`
    let content: Content
    /// The current rotation speed
    @State private var currentSpeed: Double = 0.0
    /// Bool to trigger the animation
    @State private var animate = false
    /// The body of the `View`
    public var body: some View {
        content
            .rotationEffect(.degrees(animate ? 360 : 0))
            .animation(.rotateSpeed(duration: speed).repeatForever(autoreverses: false), value: animate)
            .task {
                currentSpeed = 0
                /// Sleep for a moment to avoid clash with other animations
                try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                /// Start the animation if not done yet
                if !animate {
                    animate = true
                }
            }
            .environment(\.rotateSpeed, currentSpeed)
            .task(id: rotate) {
                /// Sleep for a moment to avoid clash with other animations
                try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                /// Build-up or slowdown the speed
                switch rotate {
                case true:
                    while currentSpeed < 1 {
                        currentSpeed = min(1, currentSpeed + (speed / 80))
                        try? await Task.sleep(for: .seconds(0.2))
                    }
                case false:
                    while currentSpeed > 0 {
                        currentSpeed = max(0, currentSpeed - (speed / 30))
                        try? await Task.sleep(for: .seconds(0.2))
                    }
                }
            }
    }
}

// MARK: - Internal Stuff

struct RotateSpeedKey: EnvironmentKey {
    static let defaultValue: Double = 1.0
}

extension EnvironmentValues {
    var rotateSpeed: Double {
        get { self[RotateSpeedKey.self] }
        set { self[RotateSpeedKey.self] = newValue }
    }
}

/// Rotating Speed State
struct RotatingSpeedState<Value: VectorArithmetic>: AnimationStateKey {
    /// projectedDuration combines the duration of the animation with the speed and the remaining animation
    /// For example: If the animation was initialized with a duration of 2.0 seconds,
    /// and half-way (at 1.0 second elapased) the speed is changed from 1.0X to 0.5X, the projectedDuration would be 3.0 seconds
    var projectedDuration: TimeInterval?
    /// the percentage of animation that has been performed so far (0.0 at the begining, and 1.0 at the end)
    var completion: Double = 0.0
    /// The time when the context was last updated
    var lastTime: TimeInterval = 0.0
    /// The default value
    static var defaultValue: Self { RotatingSpeedState() }
}


extension AnimationContext {
    var rotatingSpeedState: RotatingSpeedState<Value> {
        get { state[RotatingSpeedState<Value>.self] }
        set { state[RotatingSpeedState<Value>.self] = newValue }
    }
}

/// Rotate Speed Animation
extension Animation {
    static var rotateSpeed: Animation { .rotateSpeed(duration: 1.0) }

    static func rotateSpeed(duration: Double) -> Animation {
        Animation(RotateSpeedAnimation(duration: duration))
    }
}

struct RotateSpeedAnimation: CustomAnimation {
    /// The duration of the animation
    let duration: TimeInterval

    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V: VectorArithmetic {
        /// End animation if fully completed
        guard context.rotatingSpeedState.completion < 1.0 else {
            return nil
        }
        /// get speed from environment
        let speed = context.environment.rotateSpeed
        if let projectedDuration = context.rotatingSpeedState.projectedDuration {
            let deltaT = time - context.rotatingSpeedState.lastTime
            let timeLeft = projectedDuration - time
            let completion = context.rotatingSpeedState.completion
            context.rotatingSpeedState.completion += ((1.0 - completion) / (timeLeft / deltaT))
            context.rotatingSpeedState.projectedDuration = time + ((duration / speed) * (1.0 - completion))
        } else {
            /// first pass
            context.rotatingSpeedState.projectedDuration = (duration / speed)
            context.rotatingSpeedState.completion = (time / (duration / speed))
        }
        /// Save time for next iteration
        context.rotatingSpeedState.lastTime = time
        return value.scaled(by: min(1.0, max(0.0, context.rotatingSpeedState.completion)))
    }

    func velocity<V>(value: V, time: TimeInterval, context: AnimationContext<V>) -> V? where V: VectorArithmetic {
        if let projectedDuration = context.rotatingSpeedState.projectedDuration {
            return value.scaled(by: 1.0 / projectedDuration)
        } else {
            let speed = context.environment.rotateSpeed
            return value.scaled(by: 1.0 / (duration / speed))
        }
    }
}
