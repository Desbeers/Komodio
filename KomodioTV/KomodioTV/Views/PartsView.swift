//
//  PartsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 07/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct PartsView {
    /// Just a namespace
}

// MARK: Watch Status

extension PartsView {
    
    /// A View to show a star for unwatched items
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct WatchStatusViewModifier: ViewModifier {
        /// The Kodi  item
        let item: any KodiItem
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
    func watchStatus(of item: any KodiItem) -> some View {
        modifier(PartsView.WatchStatusViewModifier(item: item))
    }
}

// MARK: Watch Toggle

extension PartsView {
    
    /// A Button to toggle the watched status of a Kodi item
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct WatchedToggle: View {
        /// The item we want to toggle
        let item: any KodiItem
        /// The body of this View
        var body: some View {
                Button(action: {
                    Task {
                        await item.togglePlayedState()
                    }
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label(item.playcount == 0 ? "Mark as watched" : "Mark as new", systemImage: item.playcount == 0 ? "eye.fill" : "eye")
                        .labelStyle(LabelStyles.DetailsButton())
                })
        }
    }
}

// MARK: Context Menu

extension PartsView {
    
    /// View Modifier to show a Context Menu
    struct ContextMenuViewModifier: ViewModifier {
        /// The Kodi item
        let item: any KodiItem
        /// Add a Context Menu
        /// - Parameter content: The content of the View
        /// - Returns: A new View with a Context Menu added
        func body(content: Content) -> some View {
            content
                .contextMenu {
                    WatchedToggle(item: item)
                    /// - Note: Add a cancel button, because pressing 'menu' does not go back a View
                    Button(action: {
                        ///  No action needed
                    }, label: {
                        Text("Cancel")
                    })
                }
        }
    }
}

extension View {
    
    /// Shortcut for  ``PartsView/ContextMenuViewModifier``
    func contextMenu(for item: any KodiItem) -> some View {
        modifier(PartsView.ContextMenuViewModifier(item: item))
    }
}
