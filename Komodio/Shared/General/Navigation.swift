//
//  Navigation.swift
//  Komodio
//
//  Created by Nick Berendsen on 24/06/2023.
//

import SwiftUI
import SwiftlyKodiAPI

extension Modifiers {

    /// A `ViewModifier` to add navigation destinations
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct NavigationDestinations: ViewModifier {

        /// The modifier
        func body(content: Content) -> some View {
            content
            /// Set the destinations for sub-views in the stack
                .navigationDestination(for: Video.Details.Movie.self) { movie in
                    MovieView.Details(movie: movie)
                        .appendStuff()
                }
                .navigationDestination(for: Video.Details.MovieSet.self) { movieSet in
                    MovieSetView(movieSet: movieSet)
                        .appendStuff()
                }
                .navigationDestination(for: Video.Details.TVShow.self) { tvshow in
                    SeasonsView(tvshow: tvshow)
                        .appendStuff()
                }
                .navigationDestination(for: Video.Details.Episode.self) { episode in
                    UpNextView.Details(episode: episode)
                        .appendStuff()
                }
                .navigationDestination(for: Audio.Details.Artist.self) { artist in
                    MusicVideosView(artist: artist)
                        .appendStuff()
                }
                .navigationDestination(for: Video.Details.MusicVideo.self) { musicVideo in
                    MusicVideoView.Details(musicVideo: musicVideo)
                        .appendStuff()
                }
                .navigationDestination(for: List.Item.File.self) { playlist in
                    MoviesView(filter: .playlist(file: playlist))
                        .appendStuff()
                }
                .navigationDestination(for: HostItem.self) { host in
                    HostItemView(host: host)
                        .appendStuff()
                }

                .navigationDestination(for: Router.self) { router in
                    switch router {
                    case .kodiSettings:
                        KodiSettingsView()
                            .appendStuff()
                    default:
                        Text("Not implemented...")
                            .appendStuff()
                    }
                }
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/NavigationDestinations``
    func navigationDestinations() -> some View {
        modifier(Modifiers.NavigationDestinations())
    }
}

extension Modifiers {

    /// A `ViewModifier` to add random stuff to a View
    /// - Note: Movie sets are shown here as well with its own SF symbol
    struct AppendStuff: ViewModifier {
        /// The modifier
        func body(content: Content) -> some View {
#if os(tvOS)
            content
                .setSiriExit()
#elseif os(iOS)
            content
                .setBackground()
#else
            content
#endif
        }
    }
}

extension View {

    /// Shortcut to the ``Modifiers/NavigationDestinations``
    func appendStuff() -> some View {
        modifier(Modifiers.AppendStuff())
    }
}
