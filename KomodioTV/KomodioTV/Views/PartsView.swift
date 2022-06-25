//
//  PartsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 28/04/2022.
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

// MARK: Watch Toggle

extension PartsView {
    
    /// A Button to toggle the watched status of a Kodi item
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct WatchedToggle: View {
        /// The item we want to toggle
        @Binding var item: MediaItem
        /// The body of this View
        var body: some View {
                Button(action: {
                    item.togglePlayedState()
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label(item.playcount == 0 ? "Mark as watched" : "Mark as new", systemImage: item.playcount == 0 ? "eye.fill" : "eye")
                        .labelStyle(LabelStyles.DetailsButton())
                })
            Text("\(item.playcount)")
        }
    }
}

// MARK: Context Menu

extension PartsView {
    
    /// View Modifier to show a Context Menu
    struct ContextMenuViewModifier: ViewModifier {
        /// The Kodi media item
        @Binding var item: MediaItem
        /// Add a Context Menu
        /// - Parameter content: The content of the View
        /// - Returns: A new View with a Context Menu added
        func body(content: Content) -> some View {
            content
                .contextMenu {
                    WatchedToggle(item: $item)
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
    func contextMenu(for item: Binding<MediaItem>) -> some View {
        modifier(PartsView.ContextMenuViewModifier(item: item))
    }
}

// MARK: Selected Media Item

extension PartsView {
    
    /// Store the selected MediItem in the AppState Class
    struct SelectionViewModifier: ViewModifier {
        /// The AppState
        @EnvironmentObject var appState: AppState
        /// The selected media item
        let selectedItem: MediaItem?
        /// The body of this View
        func body(content: Content) -> some View {
                content
                .animation(.default, value: selectedItem)
                .onChange(of: selectedItem) { item in
                    if item != nil {
                        appState.selection = item
                    }
                }
        }
    }
}

extension View {
    
    /// Shortcut for  ``PartsView/SelectionViewModifier``
    func setSelection(of item: MediaItem?) -> some View {
        modifier(PartsView.SelectionViewModifier(selectedItem: item))
    }
}


// MARK: Page Header

extension PartsView {
    struct Header: View {
        let title: String
        let subtitle: String?
        
        var body: some View {
            VStack(alignment: .center) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.black)
                    //.frame(maxWidth: .infinity, alignment: .leading)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.callout)
                        .foregroundColor(.white)
                        //.transition(.opacity)
                        //.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 100)
            .frame(height: 140)
            //.frame(maxWidth: .infinity, alignment: .center)
            .background(.secondary)
            .clipShape(Capsule())
        }
        
    }
    
    struct Header2: View {
        let item: MediaItem
        
        var body: some View {
            HStack {
                AsyncImage(url: URL(string: item.fanart)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 225)
                        .clipShape(Capsule())
                } placeholder: {
                    Color.black
                        .frame(width: 400, height: 225)
                }
            VStack(alignment: .center) {
                Text(item.title)
                    .font(.title2)
                    .foregroundColor(.black)
                    //.frame(maxWidth: .infinity, alignment: .leading)
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.callout)
                        .foregroundColor(.white)
                        //.transition(.opacity)
                        //.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            }
            .padding(.trailing, 100)
            //.padding(.horizontal, 100)
            //.frame(height: 140)
            //.frame(maxWidth: .infinity, alignment: .center)
            .padding(4)
            .background(.secondary)
            .clipShape(Capsule())
        }
        
    }
}
