//
//  Modifiers.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of View Modifiers
enum Modifiers {
    /// Just a Namespace here...
}

// MARK: KodiItem Overlay

extension Modifiers {

    /// Overlay modifier for a KodiItem
    struct Overlay: ViewModifier {
        let item: any KodiItem
        /// The kind of overlay
        let overlay: Parts.Overlay
        /// Add a Context Menu
        /// - Parameter content: The content of the View
        /// - Returns: A new View with a Context Menu added
        func body(content: Content) -> some View {
            content
                .overlay(alignment: .bottom) {
                    
                    switch overlay {
                        
                    case .title:
                        Text(item.title)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(.thinMaterial)
                            .shadow(radius: 20)
                        
                    case .movieSet:
                        Label("Movie Set", systemImage: "circle.grid.cross.fill")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(.thinMaterial)
                            .shadow(radius: 20)
                    case .runtime:
                        Text(Parts.secondsToTime(seconds: item.runtime))
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(.thinMaterial)
                            .shadow(radius: 20)
                    case .timeToGo:
                        ProgressView(value: item.resume.position, total: item.resume.total)
                            .padding(8)
                    default:
                        EmptyView()
                    }
                }
        }
    }
}

extension View {
    
    /// Shortcut to the ``Modifiers/Overlay``
    func itemOverlay(for item: any KodiItem, overlay: Parts.Overlay = .none) -> some View {
        modifier(Modifiers.Overlay(item: item, overlay: overlay))
    }
}

// MARK: Watch Status

extension Modifiers {
    
    /// A View to show a star for unwatched items
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct WatchStatus: ViewModifier {
        /// The Kodi  item
        let item: any KodiItem
        /// The modifier
        func body(content: Content) -> some View {
            content
                .overlay(alignment: .topTrailing) {
                    Image(systemName: item.media == .movieSet ? "circle.grid.cross.fill" : item.resume.position == 0 ? "star.fill" : "circle.lefthalf.filled")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                        .opacity(item.playcount == 0 || item.resume.position != 0 ? 1 : 0)
                }
        }
    }
}

extension View {
    
    /// Shortcut to the ``Modifiers/WatchStatus``
    func watchStatus(of item: any KodiItem) -> some View {
        modifier(Modifiers.WatchStatus(item: item))
    }
}
