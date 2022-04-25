//
//  PartsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct PartsView {
///
}

extension PartsView {
    
    /// The menu items
    struct MenuItems: View {
        var body: some View {
            HStack {
                ForEach(Route.menuItems, id: \.self) { item in
                    RouterLink(item: item) {
                        Label(item.title, systemImage: item.symbol)
                            .labelStyle(LabelStyles.GridItem())
                            .frame(width: 200)
                            .padding()
                    }
                    //.frame(width: 120, height: 100)
                }
            }
            .buttonStyle(ButtonStyles.GridItem())
            .padding()
            .tvOS { $0.padding(.vertical)}
        }
    }
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
    
    /// A View to show a star for unwatched items
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct WatchStatusViewModifier: ViewModifier {
        /// The Kodi media item
        @Binding var item: MediaItem
        /// The modifier
        func body(content: Content) -> some View {
            content
                .overlay(alignment: .topTrailing) {
                    Image(systemName: item.media == .movieSet ? "circle.grid.cross.fill" : "star.fill")
                        .macOS { $0.font(.headline) }
                        .tvOS { $0.font(.subheadline) }
                        .foregroundColor(.yellow)
                        .opacity(item.playcount == 0 ? 1 : 0)
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
