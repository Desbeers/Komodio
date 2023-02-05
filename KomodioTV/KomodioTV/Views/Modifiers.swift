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
                        Label(title: {
                            Text("Movie Set")
                        }, icon: {
                            Image(systemName: "circle.grid.cross.fill")
                                .imageScale(.small)
                        })
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(2)
                        .background(.thinMaterial)
                        .shadow(radius: 20)
                    case .runtime:
                        Text(Parts.secondsToTime(seconds: item.duration))
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .padding(2)
                            .background(.thinMaterial)
                            .shadow(radius: 20)
                    case .timeToGo:
                        /// ProgressView flickers a lot, so, a custom View...
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .opacity(0.6)
                                    .foregroundColor(.black)
                                
                                Rectangle()
                                    .frame(width: min(CGFloat(item.resume.position / item.resume.total) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                                    .foregroundColor(.gray)
                            }
                            .cornerRadius(8)
                        }
                        .frame(height: 10)
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

// MARK: Context Menu

extension Modifiers {
    
    /// View Modifier to show a Context Menu
    struct ContextMenu: ViewModifier {
        /// The Kodi item
        let item: any KodiItem
        /// Add a Context Menu
        /// - Parameter content: The content of the View
        /// - Returns: A new View with a Context Menu added
        func body(content: Content) -> some View {
            content
                .contextMenu {
                    if item.resume.position != 0 {
                        Text("'\(item.title)' is partly watched")
                        PartsView.ResumeToggle(item: item)
                    } else {
                        Text("'\(item.title)'")
                        switch item {
                        case let movieSet as Video.Details.MovieSet:
                            PartsView.MovieSetToggle(set: movieSet)
                        default:
                            PartsView.WatchedToggle(item: item)
                        }
                    }
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
    
    /// Shortcut for  ``Modifiers/ContextMenu``
    func contextMenu(for item: any KodiItem) -> some View {
        modifier(Modifiers.ContextMenu(item: item))
    }
}
