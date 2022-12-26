//
//  MainView.swift
//  KomodioTV (tvOS)
//
//  Created by Nick Berendsen on 02/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// Bool if the sidebar has focus
    @FocusState var isFocused: Bool
    /// The color scheme
    @Environment(\.colorScheme) var colorScheme
    /// The body of the View
    var body: some View {
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
            /// Set the destinations for sub-views
                .navigationDestination(for: Video.Details.Movie.self, destination: { movie in
                    MovieView.Details(movie: movie)
                        .task {
                            scene.background = movie.fanart
                        }
                        .setSafeAreas()
                })
                .navigationDestination(for: Video.Details.MovieSet.self, destination: { movieSet in
                    MovieSetView(movieSet: movieSet).setSafeAreas()
                        .task {
                            scene.background = movieSet.fanart
                        }
                        .setSafeAreas()
                })
                .navigationDestination(for: Video.Details.TVShow.self, destination: { tvshow in
                    SeasonsView(tvshow: tvshow)
                        .task {
                            scene.background = tvshow.fanart
                        }
                        .setSafeAreas()
                })
                .navigationDestination(for: Audio.Details.Artist.self, destination: { artist in
                    MusicVideosView(artist: artist)
                        .task {
                            scene.background = artist.fanart
                        }
                        .setSafeAreas()
                })
        }
        /// Put the ``SidebarView`` into the `safe area`.
        .safeAreaInset(edge: .leading, alignment: .top, spacing: 0) {
            SidebarView()
                .fixedSize()
                .frame(width: isFocused ? KomodioApp.sidebarWidth : KomodioApp.sidebarCollapsedWidth, alignment: .center)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.trailing)
                .opacity(isFocused ? 1 : 0.2)
                .background(.regularMaterial)
                .focused($isFocused)
                .clipped()
                .ignoresSafeArea()
        }
        .animation(.default, value: isFocused)
        .animation(.default, value: scene.sidebarSelection)
        .animation(.default, value: scene.navigationStackPath)
        .environmentObject(scene)
    }
}
