//
//  ContentView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 15/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The body of the View
    var body: some View {
        switch scene.contentSelection {
        case .start:

            VStack {

                ForEach(kodi.bonjourHosts, id: \.ip) { host in
                    Button(action: {
                        if AppState.shared.host?.ip != host.ip {
                            var values = HostItem()
                            values.ip = host.ip
                            AppState.saveHost(host: values)
                        }
                    }, label: {
                        Label(title: {
                            Text(host.name)
                        }, icon: {
                            Image(systemName: "globe")
                                .foregroundColor(AppState.shared.host?.ip == host.ip ? .green : .gray)
                        })
                    })
                }

                Button(action: {
                    Task {
                        scene.mainSelection = 0
                        scene.navigationSubtitle = ""
                        await KodiConnector.shared.loadLibrary(cache: false)
                    }
                }, label: {
                    Label("Reload Library", systemImage: "arrow.triangle.2.circlepath")
                })
                .disabled(kodi.state != .loadedLibrary)
                StartView()
                    .disabled(true)
            }
            .buttonStyle(.plain)
            .setSafeAreas()
        case .movies:
            MoviesView()
        case .unwatchedMovies:
            MoviesView(filter: .unwatched)
        case .tvshows:
            TVShowsView()
        case .seasons(let tvshow):
            TVShowsView(selectedTVShow: tvshow)
        case .unwachedEpisodes:
            UpNextView()
        case .musicVideos:
            ArtistsView()
        case .search:
            SearchView()
                .padding(.horizontal, KomodioApp.sidebarCollapsedWidth)
                .setSafeAreas()
//        case .kodiSettings:
//            KodiSettings()
        default:
            Text("Not implemented")
        }
    }
}
