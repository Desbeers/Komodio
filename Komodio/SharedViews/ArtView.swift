//
//  ArtView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of structs to view Kodi art
struct ArtView {
    /// Just a Namespace here...
}

extension ArtView {
    
    /// A View to show the fanart of a Kodi item
    struct Fanart: View {
        /// The fanart URL
        let fanart: String
        /// The View
        var body: some View {
            if fanart.isEmpty {
                EmptyView()
            } else {
                AsyncImage(url: URL(string: fanart)!) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 150)
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        EmptyView()
                    @unknown default:
                        /// Since the AsyncImagePhase enum isn't frozen,
                        /// we need to add this currently unused fallback.
                        EmptyView()
                    }
                }
            }
        }
    }
    
    /// A View to show the poster of a Kodi item in a list
    struct PosterList: View {
        /// The poster
        let poster: String
        /// The View
        var body: some View {
            Group {
                if poster.isEmpty {
                    Image("No Poster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    AsyncImage(url: URL(string: poster)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image("No Poster")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .macOS { $0.frame(width: 100) }
            .tvOS { $0.frame(height: 200) }
            .iOS { $0.frame(width: 100) }
        }
    }

    /// A View to show the poster of a Kodi item in a list
    struct PosterEpisode: View {
        /// The poster
        let poster: String
        /// The View
        var body: some View {
            Group {
                if poster.isEmpty {
                    Image("No Poster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    AsyncImage(url: URL(string: poster)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image("No Poster")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .macOS { $0.frame(width: 150) }
            .tvOS { $0.frame(height: 300) }
            .iOS { $0.frame(width: 100) }
        }
    }
    
    /// A View to show the poster of a Kodi item in a detail View
    struct PosterDetail: View {
        /// The Kodi item
        let item: MediaItem
        /// The View
        var body: some View {
            Group {
                if item.poster.isEmpty {
                    Image("No Poster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    AsyncImage(url: URL(string: item.poster),
                               transaction: Transaction(animation: .easeInOut)) { phase in
                        switch phase {
                        case .empty:
                            Image("Loading Poster")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image("No Poster")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}
