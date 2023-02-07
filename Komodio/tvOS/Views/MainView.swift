//
//  MainView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for the main navigation (tvOS)
struct MainView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// Bool if the sidebar has focus
    @FocusState var isFocused: Bool

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        NavigationStack(path: $scene.navigationStackPath) {
            ContentView()
            /// Set the destinations for sub-views in the stack
                .navigationDestination(for: Video.Details.Movie.self, destination: { movie in
                    MovieView.Details(movie: movie)
                        .setSafeAreas()
                })
                .navigationDestination(for: Video.Details.MovieSet.self, destination: { movieSet in
                    MovieSetView(movieSet: movieSet)
                        .setSafeAreas()
                })
                .navigationDestination(for: Video.Details.TVShow.self, destination: { tvshow in
                    SeasonsView(tvshow: tvshow)
                        .setSafeAreas()
                })
                .navigationDestination(for: Audio.Details.Artist.self, destination: { artist in
                    MusicVideosView(artist: artist)
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
                .background(.regularMaterial.opacity(isFocused ? 1 : 0.8))
                .focused($isFocused)
                .clipped()
                .ignoresSafeArea()
        }
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                scene.mainSelection = 0
                isFocused = true
            }
        }
        .opacity(scene.showSettings ? 0 : 1)
        .fullScreenCover(isPresented: $scene.showSettings) {
            KodiSettingsView.FullScreen()
        }
        .animation(.default, value: isFocused)
        .animation(.default, value: scene.mainSelection)
        .environmentObject(scene)
    }
}
