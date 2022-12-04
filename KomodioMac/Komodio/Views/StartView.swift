//
//  StartView.swift
//  Komodio (macOS)
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View when starting Komodio
struct StartView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            switch kodi.state {
            case .loadedLibrary:
                VStack(spacing: 20) {
                    statistics
                        .font(.body)
                        .padding()
                }
            case .offline, .failure:
                Text("The host is offline")
            default:
                Text("Loading the library...")
            }
        }
        .font(.system(size: 30))
        .animation(.default, value: kodi.state)
    }
    @ViewBuilder var statistics: some View {
        VStack {
            Text(AppState.shared.host?.description ?? "No host selected")
                .font(.system(size: 30))
            if !kodi.library.movies.isEmpty {
                Button(
                    action: {
                        scene.sidebar = .movies
                    },
                    label: {
                        Label("\(kodi.library.movies.count) Movies", systemImage: Router.movies.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
                let unwatched = kodi.library.movies.filter({$0.playcount == 0})
                if !unwatched.isEmpty {
                    Button(
                        action: {
                            scene.sidebar = .unwatchedMovies
                        },
                        label: {
                            Label("\(unwatched.count) Unwatched Movies", systemImage: "eye")
                                .labelStyle(StatisticsLabel(subItem: true))
                        })
                }
            }
            if !kodi.library.tvshows.isEmpty {
                Button(
                    action: {
                        scene.sidebar = .tvshows
                    },
                    label: {
                        Label("\(kodi.library.tvshows.count) TV shows", systemImage: Router.tvshows.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
                let unwatched = kodi.library.episodes.filter({$0.playcount == 0})
                if !unwatched.isEmpty {
                    Button(
                        action: {
                            scene.sidebar = .unwachedEpisodes
                        },
                        label: {
                            Label("\(unwatched.count) Unwatched Episodes", systemImage: "eye")
                                .labelStyle(StatisticsLabel(subItem: true))
                        })
                }
            }
            if !kodi.library.musicVideos.isEmpty {
                Button(
                    action: {
                        scene.sidebar = .musicVideos
                    },
                    label: {
                        Label("\(kodi.library.musicVideos.count) Music Videos", systemImage: Router.musicVideos.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
            }
            Spacer()
        }
        .buttonStyle(.plain)
    }
}

extension StartView {
    
    /// Label style for statistics
    private struct StatisticsLabel: LabelStyle {
        var subItem: Bool = false
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(subItem ? .gray : .accentColor)
                
                    .frame(width: 40)
                configuration.title
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: subItem ? 16 : 20))
            .padding(.vertical, subItem ? 0 : 10)
            .padding(.leading, subItem ? 20 : 0)
        }
    }
}
