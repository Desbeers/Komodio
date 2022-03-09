//
//  PartsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct PartsView {
///
}

extension PartsView {
    
    /// A Button to toggle the watched status of a Kodi item
    struct WatchedToggle: View {
        /// The item we want to toggle
        @Binding var item: MediaItem
        /// The View
        var body: some View {
            Button(action: {
                item.togglePlayedState()
            }, label: {
                Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                    .macOS { $0.frame(width: 110) }
                    .tvOS { $0.frame(width: 300) }
            })
                .buttonStyle(.bordered)
                .animation(.default, value: item)
        }
    }
}

extension PartsView {
    
    /// A View to show the watched status of a Kodi item
    struct WatchStatusViewModifier: ViewModifier {
        /// The Kodi media item
        @Binding var item: MediaItem
        /// The modifier
        func body(content: Content) -> some View {
            content
                .overlay(alignment: .topTrailing) {
                    Image(systemName: item.playcount == 0 ? "star.fill" : "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(item.playcount == 0 ? .yellow : .green)
                }
        }
    }
}

extension PartsView {
    /// View a rotating record
    struct RotatingIcon: View {
        /// The animation
        var foreverAnimation: Animation {
            Animation.linear(duration: 3.6)
                .repeatForever(autoreverses: false)
        }
        /// The state of the animation
        @State var rotate: Bool = false
        /// The view
        var body: some View {
            Image("Huge Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(Angle(degrees: self.rotate ? 360 : 0.0))
                .animation(rotate ? foreverAnimation : .easeInOut, value: rotate)
                .task {
                    /// Give it a moment to settle; else the animation can be strange on macOS
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        rotate = true
                    }
                }
        }
    }
}
