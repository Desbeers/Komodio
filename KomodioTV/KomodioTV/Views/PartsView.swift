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
    /// Don't add an buttonstyle, else it will not work as contets menu
    struct WatchedToggle: View {
        /// The item we want to toggle
        @Binding var item: MediaItem
        /// The View
        var body: some View {
                Button(action: {
                    item.togglePlayedState()
                }, label: {
                    //Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                    Label(item.playcount == 0 ? "Mark as watched" : "Mark as new", systemImage: item.playcount == 0 ? "eye.fill" : "eye")
                        .labelStyle(LabelStyles.DetailsItem())
                })
        }
    }
}

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
