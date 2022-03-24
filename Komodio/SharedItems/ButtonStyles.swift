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
    
    /// Button style for a media item
    struct MediaItem: PrimitiveButtonStyle {
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
        private var selected: Bool {
            if router.selectedMediaItem == item {
                return true
            }
            return false
        }
        /// The View
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            
            
                .cornerRadius(6)
                .zIndex(focused ? 2 : 1)
                .padding(.all, 2)
                .background(Color("ListButtonColor").opacity(focused ? 1 : 0.8))
                .cornerRadius(6)
                
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.2), radius: focused ? 5 : 0 , x: 0, y: focused ? 10 : 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(selected ? Color.accentColor : Color.clear, lineWidth: 1)
                )
                .scaleEffect(focused ? 1.05 : 1)
                .buttonStyle(.plain)
                .animation(.easeInOut, value: isHovered)
                .animation(.easeInOut, value: selected)
                .onHover { hover in
                    isHovered = hover
                }
                .padding(.vertical, 15)
                .padding(.bottom, 10)
                .gesture(TapGesture(count: 2).onEnded {
                    print("double clicked")
                    router.setSelectedMediaItem(item: item)
                    configuration.trigger()
                })
                .gesture(TapGesture(count: 1).onEnded {
                    print("single clicked")
                    if router.selectedMediaItem == item {
                        configuration.trigger()
                    } else {
                        router.setSelectedMediaItem(item: item)
                    }
                })
                //.background(.green)
                //.border(.black)
        }
    }
}

//extension ButtonStyles {
//
//    /// Button style for a Kodi item
//    struct MediaItem: ButtonStyle {
//        /// The focus state from the environment
//        @Environment(\.isFocused) var focused: Bool
//        /// Is the button hovered or not
//        @State private var isHovered = false
//        /// The Kodi item
//        var item: SwiftlyKodiAPI.MediaItem
//        /// The function to make a button style for a Kodi item
//        func makeBody(configuration: Configuration) -> some View {
//            configuration.label
//            /// Slow in the simulator; check on a real aTV
//                .background(isHovered ? .thickMaterial : .ultraThinMaterial)
//                //.background(Color("ListButtonColor").opacity(isHovered ? 0.8 : 0.5))
//                .cornerRadius(6)
//                .padding(.horizontal, 40)
//                .padding(.vertical, 15)
//                .onHover { hover in
//                    isHovered = hover
//                }
//                .scaleEffect(isHovered ? 1.02 : 1)
//                .animation(.default, value: isHovered)
//                .opacity(configuration.isPressed ? 0.8 : 1)
//                .shadow(color: .secondary, radius: 20 , x: 0, y: isHovered ? 20 : 5)
//        }
//    }
//}

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
            let configuration: ButtonStyles.GridItem.Configuration
            /// The View
            var body: some View {
                configuration.label
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(isHovered ? .thickMaterial : .ultraThinMaterial)
                    .cornerRadius(6)
                    .scaleEffect(isHovered ? 1.02 : 1)
                    //.shadow(radius: 1)
                    .animation(.easeInOut, value: isHovered)
                    .onHover { hover in
                        isHovered = hover
                    }
            }
        }
    }
}
