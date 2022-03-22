//
//  ItemsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI

/// An 'Item' can be any kind of ``MediaItem``; e.g., movie, tvshow, episode etc...
struct ItemsView {
    /// Just a Namespace here...
}

extension ItemsView {
    
    /// Wrap the Kodi items in a List or a LazyVStack
    struct List<Content: View>: View {
        
        @EnvironmentObject var router: Router
        
        private var content: Content
        /// Build the View
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        /// The View
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        content
                    }
                    /// Give it some padding because the `TitleHeader` is on top in a `ZStack`
                    .macOS { $0.padding(.top, 100)}
                    .tvOS { $0.padding(.top, 200)}
                    .iOS { $0.padding(.top, 120)}
                }
                .task {
                    /// Scroll to the last selected item on this View
                    
                    logger("Scrolling to \(router.currentRoute.itemID)")
#if os(tvOS)
                    /// Focus on top for tvOS, then it will select the last item again
                    /// - Note: Don't scroll on the homepage, focus will be confused...
                    if router.currentRoute.route != .home {
                        proxy.scrollTo(router.currentRoute.itemID, anchor: .top)
                    }
#else
                    withAnimation(.linear(duration: 1)) {
                        proxy.scrollTo(router.currentRoute.itemID, anchor: .center)
                    }
#endif
                }
            }
        }
    }
}

extension ItemsView {
    
    struct Item: View {
        /// The ``MediaItem`` to show in this View
        @Binding var item: MediaItem
        var body: some View {
            
            switch item.media {
            case .movie:
                MoviesView.Item(movie: $item)
            case .movieSet:
                MoviesView.SetItem(movieSet: item)
            case .tvshow:
                TVshowsView.Item(tvshow: $item)
            case .musicVideo:
                MusicVideosView.Item(musicvideo: $item)
            default:
                RouterLink(item: .details(item: item)) {
                    Basic(item: $item)
                }
                .buttonStyle(ButtonStyles.MediaItem(item: item))
            }
        }
    }
}

extension ItemsView {
    
    /// A basic View for a Kodi item
    struct Basic: View {
        /// The ``MediaItem`` to show in this View
        @Binding var item: MediaItem
        /// The View
        var body: some View {
            HStack(spacing: 0) {
                ArtView.PosterList(poster: item.poster)
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.title)
                            .font(.headline)
                        Spacer()
                        Text(item.details)
                            .font(.caption)
                    }
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.caption.italic())
                    }
                    Divider()
                    Text(item.description)
                        .lineLimit(2)
                }
                .padding(.horizontal)
            }
            .watchStatus(of: $item)
            .contextMenu {
                Button(action: {
                    item.togglePlayedState()
                }, label: {
                    Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                })
            }
        }
    }
    
    /// The description of a Kodi item
    struct Description: View {
        let description: String
        var body: some View {
            Text(description)
        }
    }
    
    
    
    
    struct FanartModifier: ViewModifier {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The fanart
        let fanart: String
        /// The modifier
        func body(content: Content) -> some View {
            content
                .background {
                    VStack {
                        if !fanart.isEmpty {
                            ArtView.Fanart(fanart: fanart)
                                .macOS { $0.overlay(Material.ultraThinMaterial) }
                                .tvOS { $0.overlay(Material.thinMaterial) }
                                //.transition(.opacity)
                        } else {
                            EmptyView()
                        }
                    }
                    //.transition(.opacity)
                }
                //.animation(.default, value: router.selectedMediaItem)
        }
    }
}
