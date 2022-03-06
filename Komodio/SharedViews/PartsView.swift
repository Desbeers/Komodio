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
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The item we want to toggle
        @Binding var item: MediaItem
        /// The View
        var body: some View {
            Button(action: {
                item.toggleWatchedState()
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
