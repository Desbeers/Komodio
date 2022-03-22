//
//  ButtonStyles.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of Button syles for macOS and iOS
/// - Note: tvOS is so much different that it has its own file
struct ButtonStyles {
    /// Just a Namespace here...
}

extension ButtonStyles {
    
    /// Button style for a Home item
    struct HomeItem: PrimitiveButtonStyle {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The Kodi item
        var item: SwiftlyKodiAPI.MediaItem
        /// Is the button hovered or not
        @State private var isHovered = false
        private var focused: Bool {
            if isHovered || router.selectedMediaItem == item {
                return true
            }
            return false
        }
        /// The View
        func makeBody(configuration: Configuration) -> some View {
            //Button(action: configuration.trigger, label: {
 
                    configuration.label


                    .cornerRadius(6)
                    .zIndex(focused ? 2 : 1)
                    .padding(.all, 2)
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .padding(.bottom, 20)
                    .scaleEffect(focused ? 1.05 : 1)
                    .shadow(color: .secondary, radius: focused ? 10 : 0 , x: 0, y: focused ? 10 : 0)
            //})
                .buttonStyle(.plain)
                .animation(.easeInOut, value: isHovered)
                .onHover { hover in
                    isHovered = hover
                }
                .padding(.vertical, 15)
                .gesture(TapGesture(count: 2).onEnded {
                    print("double clicked")
                    router.setSelectedMediaItem(item: router.selectedMediaItem == item ? nil : item)
                    configuration.trigger()
                })
                .gesture(TapGesture(count: 1).onEnded {
                    print("single clicked")
                    router.setSelectedMediaItem(item: router.selectedMediaItem == item ? nil : item)
                })
        }
    }
}

extension ButtonStyles {
    
    /// Button style for a Kodi item
    struct MediaItem: ButtonStyle {
        /// The focus state from the environment
        @Environment(\.isFocused) var focused: Bool
        /// Is the button hovered or not
        @State private var isHovered = false
        /// The Kodi item
        var item: SwiftlyKodiAPI.MediaItem
        /// The function to make a button style for a Kodi item
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            /// Slow in the simulator; check on a real aTV
                .background(isHovered ? .thickMaterial : .ultraThinMaterial)
                //.background(Color("ListButtonColor").opacity(isHovered ? 0.8 : 0.5))
                .cornerRadius(6)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .onHover { hover in
                    isHovered = hover
                }
                .scaleEffect(isHovered ? 1.02 : 1)
                .animation(.default, value: isHovered)
                .opacity(configuration.isPressed ? 0.8 : 1)
                .shadow(color: .secondary, radius: 20 , x: 0, y: isHovered ? 20 : 5)
        }
    }
}

extension ButtonStyles {
    
    /// Button style for a Grid item
    struct GridItem: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            GridItemView(configuration: configuration)
        }
        /// The View
        private struct GridItemView: View {
            /// Is the button hovered or not
            @State private var isHovered = false
            /// The configaration of the Button
            let configuration: ButtonStyles.MediaItem.Configuration
            /// The View
            var body: some View {
                configuration.label
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(isHovered ? 0.4 : 0.2))
                    .cornerRadius(6)
                    .padding()
                    .scaleEffect(isHovered ? 1.02 : 1)
                    .animation(.easeInOut, value: isHovered)
                    .onHover { hover in
                        isHovered = hover
                    }
            }
        }
    }
}
