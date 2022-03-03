//
//  ItemsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

/// An 'Item' can be any kind of ``KodiItem``; e.g., movie, tvshow, episode etc...
struct ItemsView {
    /// Just a Namespace here...
}

extension ItemsView {

    /// Wrap the Kodi items in a List or a LazyVStack
    struct List<Content: View>: View {
        private var content: Content
        /// StackNavView
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        ///The View
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    content
                }
                /// On macOS, give it some padding because the TitleHeader is on top
                .macOS { $0.padding(.top, 60)}
            }
            .tvOS { $0.fanartBackground().ignoresSafeArea() }
            .macOS { $0.ignoresSafeArea() }
            .iOS { $0.ignoresSafeArea(.all, edges: .bottom) }
        }
    }
}


extension ItemsView {
    struct Item: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The Navigator model
        @EnvironmentObject var navigator: Navigator
        /// The ``KodiItem`` to show in this View
        @Binding var item: KodiItem
        var body: some View {
            
            switch item.media {
            case .movie:
                MoviesView.Item(movie: $item, filter: appState.filter)
            case .tvshow:
                TVshowsView.Item(tvshow: $item, filter: appState.filter)
            case .musicvideo:
                MusicVideosView.Item(musicvideo: $item)
            default:
                StackNavLink(path: "\(navigator.path)/Details/\(item.id)",
                             filter: appState.filter,
                             destination: DetailsView(item: item.binding())
                ) {
                    Basic(item: $item)
                }
                .buttonStyle(ButtonStyles.KodiItem(item: item))
            }
        }
    }
}

extension ItemsView {
    
    /// A basic View for a Kodi item
    struct Basic: View {
        /// The ``KodiItem`` to show in this View
        @Binding var item: KodiItem
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
    
        
    /// A View to show the watched status of a Kodi item
    struct FanartModifier: ViewModifier {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The modifier
        func body(content: Content) -> some View {
            content
                .background {
                    if let fanart = appState.filter.fanart, !fanart.isEmpty {
                        ZStack {
                            Color("Background")
                            ArtView.Fanart(fanart: fanart)
                                .opacity(0.3)
                                .blur(radius: 4)
                        }
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
