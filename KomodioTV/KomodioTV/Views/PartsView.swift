//
//  PartsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 28/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct PartsView {
    struct PartsView {
        /// Just a namespace
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
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                        .opacity(item.playcount == 0 ? 1 : 0)
                }
        }
    }
}

extension View {
    /// Shortcut to the ``WatchStatusViewModifier``
    func watchStatus(of item: Binding<MediaItem>) -> some View {
        modifier(PartsView.WatchStatusViewModifier(item: item))
    }
}


extension PartsView {
    struct ContextMenuViewModifier: ViewModifier {
        /// The Kodi media item
        @Binding var item: MediaItem
        func body(content: Content) -> some View {
            content
                .contextMenu {
                    WatchedToggle(item: $item)
                    /// The cancel button, because pressing 'menu' does not go back
                    Button(action: {
                        //
                    }, label: {
                        Text("Cancel")
                    })
                }
        }
    }
}

extension View {
    func itemContextMenu(for item: Binding<MediaItem>) -> some View {
        modifier(PartsView.ContextMenuViewModifier(item: item))
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
                })
        }
    }
}
