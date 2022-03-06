//
//  ItemsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
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
        /// StackNavView
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        ///The View
        var body: some View {
            ScrollView {
#if os(tvOS)
                if router.routes.count > 1 {
                    PartsView.TitleHeader()
                }
#endif
                LazyVStack(spacing: 0) {
                    content
                }
                /// On macOS, give it some padding because the `TitleHeader` is on top in a `ZStack`
                .macOS { $0.padding(.top, 60)}
                /// Move the content below the tabs on tvOS
                /// - Note: Padding is the space needed by the `TitleHeader` above to avoid jumping
                .tvOS { $0.padding(.top, router.routes.count == 1 ? 206 : 0) }
            }
            .tvOS { $0.fanartBackground(fanart: router.fanart).ignoresSafeArea() }
            .macOS { $0.ignoresSafeArea() }
            .iOS { $0.fanartBackground(fanart: router.fanart).ignoresSafeArea(.all, edges: .bottom) }
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
            case .musicvideo:
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
                    item.toggleWatchedState()
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
        let fanart: String
        /// The modifier
        func body(content: Content) -> some View {
            content
                .background {
                    if !fanart.isEmpty {
                        ArtView.Fanart(fanart: fanart)
                            .opacity(0.3)
                            .blur(radius: 4)
                            .macOS {$0.edgesIgnoringSafeArea(.all) }
                            .tvOS { $0.edgesIgnoringSafeArea(.all) }
                            .iOS { $0.edgesIgnoringSafeArea(.bottom) }
                    } else {
                        EmptyView()
                    }
                }
        }
    }
}
