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
        /// The content that is going to be wrapped
        private var content: Content
        /// Show details of the optional selected item
        private var details: MediaItem?
        /// Build the View
        init(details: MediaItem? = nil, @ViewBuilder content: () -> Content) {
            self.details = details
            self.content = content()
        }
        /// The View
        var body: some View {
            ZStack(alignment: .topLeading) {
                ScrollViewReader { proxy in
                    ScrollView {
                        //LazyVStack(spacing: 0) {
                            content
                        //}
                        /// Give it some padding because the `TitleHeader` is on top in a `ZStack`
                        .macOS { $0.padding(.top, 100)}
                        //.tvOS { $0.padding(.top, 180)}
                        .iOS { $0.padding(.top, 120)}
                    }
                    /// tvOS can't scroll into the `TitleHeader` because the `scrollTo` is messy...
                    .tvOS { $0.padding(.top, 180)}
                    .task {
                        /// Scroll to the last selected item on this View
#if os(tvOS)
                        /// Focus on top for tvOS, then it will select the last item row again
                        /// - Note: Exceptions because otherwise tvOS will be upset...
                        if router.currentRoute.route != .home && router.currentRoute.route != .genres {
                            proxy.scrollTo(router.currentRoute.item?.id ?? "", anchor: .top)
                        }
#else
                        withAnimation(.linear(duration: 1)) {
                            //logger("Scrolling to \(router.currentRoute.itemID)")
                            proxy.scrollTo(router.currentRoute.item?.id ?? "", anchor: .center)
                        }
#endif
                    }
                }
                /// Make room for the details
                .macOS { $0.padding(.leading, details != nil ? 330 : 0) }
                .tvOS { $0.padding(.leading, details != nil ? 500 : 0) }
                if details != nil {
                    ItemsView.Details(item: details!)
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
            case .movieSet:
                RouterLink(item: .moviesSet(set: item)) {
                    Basic(item: $item)
                }
                .buttonStyle(ButtonStyles.MediaItem(item: item))
            case .tvshow:
                RouterLink(item: .episodes(tvshow: item)) {
                    ItemsView.Basic(item: item.binding())
                }
                .buttonStyle(ButtonStyles.MediaItem(item: item))
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
                ArtView.BasicPoster(item: item)
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
                        .lineLimit(3)
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
    
    struct Details: View {
        
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        
        let item: MediaItem
        var body: some View {
            VStack {
                switch item.media {
                case .episode:
                    ArtView.SeasonPoster(item: item)
                case .artist:
                    VStack {
                        if !item.details.isEmpty {
                            Text(item.details)
                                .font(.caption)
                            Divider()
                        }
                        Text(item.description)
                    }
                    .padding()
                case .movieSet:
                    VStack(alignment: .leading) {
                        DetailsBasic(item: item)
                        if !item.description.isEmpty {
                            Divider()
                        }
                        ForEach(kodi.media.filter { $0.media == .movie && $0.movieSetID == item.movieSetID}) { movie in
                            Label(movie.title, systemImage: "film")
                            
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                default:
                    DetailsBasic(item: item)
                        .padding()
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(6)
            .shadow(radius: 1)
            .macOS { $0.padding(.top, 100).frame(width: 300).padding() }
            .tvOS { $0.padding(.top, 200).frame(width: 500).padding() }
            .iOS { $0.padding(.top, 100).frame(width: 300).padding() }
            //.transition(.opacity)
        }
    }
    
    /// The basic details of a Kodi media item
    struct DetailsBasic: View {
        let item: MediaItem
        var body: some View {
            VStack {
                Text(item.title)
                    .font(.headline)
                if !item.details.isEmpty {
                    Text(item.details)
                        .font(.caption)
                }
                Divider()
                Text(item.description)
            }
            //.padding()
        }
    }
    
    
    
    struct BackgroundModifier: ViewModifier {
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
                            ArtView.Background(fanart: fanart)
                                .blur(radius: 5)
                                .opacity(0.2)
                        } else {
                            EmptyView()
                        }
                    }
                }
        }
    }
}
