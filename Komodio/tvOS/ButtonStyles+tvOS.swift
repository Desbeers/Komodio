//
//  ButtonStyles+tvOS.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of Button syles for tvOS
struct ButtonStyles {
    /// Just a Namespace here...
}

extension ButtonStyles {
    
    /// Button style for a Home item
    struct HomeItem: ButtonStyle {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The focus state from the environment
        @Environment(\.isFocused) var focused: Bool
        /// The Kodi item
        var item: SwiftlyKodiAPI.MediaItem
        /// The View
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .cornerRadius(6)
            .zIndex(focused ? 2 : 1)
            .padding(.all, 4)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .scaleEffect(focused ? 1.05 : 1)
            .shadow(color: .secondary, radius: focused ? 10 : 0 , x: 0, y: focused ? 10 : 0)
            .animation(.default, value: focused)
            .padding(.vertical, 40)
            .padding(.bottom, 10)
            .onChange(of: focused) { focus in
                if focus {
                    appState.setHoveredMediaItem(item: item)
                } else if item == appState.hoveredMediaItem {
                    appState.setHoveredMediaItem(item: nil)
                }
            }
        }
    }

    
    /// Button style for a Kodi item
    struct MediaItem: ButtonStyle {
        /// The focus state from the environment
        @Environment(\.isFocused) var focused: Bool
        /// The Kodi item
        var item: SwiftlyKodiAPI.MediaItem
        /// The function to make a button style for a Kodi item
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            /// Slow in the simulator; check on a real aTV
            //.background(focused ? .thickMaterial : .ultraThinMaterial)
                .background(Color("ListButtonColor").opacity(focused ? 1 : 0.5))
                .cornerRadius(12)
                .shadow(radius: focused ? 20 : 0, y: focused ? 20 : 0)
                .padding(.horizontal, 160)
                .padding(.vertical, 30)
                .onChange(of: focused) { focus in
                    if focus {
                        //AppState.setHoveredMediaItem(item: item)
                    }
                }
                .scaleEffect(focused ? 1.05 : 1)
                .animation(.default, value: focused)
                .opacity(configuration.isPressed ? 0.8 : 1)
        }
    }
    
    /// Button style for a Grid item
    struct GridItem: PrimitiveButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            return Button(action: configuration.trigger, label: {
                configuration
                    .label
                    .background(Color("ListButtonColor").opacity(0.5))
            })
            .buttonStyle(.card)
        }
    }
}
