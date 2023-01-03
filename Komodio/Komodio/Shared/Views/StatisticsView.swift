//
//  StatisticsView.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for library statistics
struct StatisticsView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        VStack {
            if !kodi.library.movies.isEmpty {
                Button(
                    action: {
                        scene.sidebarSelection = .movies
                    },
                    label: {
                        Label("\(kodi.library.movies.count) Movies", systemImage: Router.movies.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
                let unwatched = kodi.library.movies.filter({$0.playcount == 0})
                if !unwatched.isEmpty {
                    Button(
                        action: {
                            scene.sidebarSelection = .unwatchedMovies
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
                        scene.sidebarSelection = .tvshows
                    },
                    label: {
                        Label("\(kodi.library.tvshows.count) TV shows", systemImage: Router.tvshows.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
                let unwatched = kodi.library.episodes.filter({$0.playcount == 0})
                if !unwatched.isEmpty {
                    Button(
                        action: {
                            scene.sidebarSelection = .unwachedEpisodes
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
                        scene.sidebarSelection = .musicVideos
                    },
                    label: {
                        Label("\(kodi.library.musicVideos.count) Music Videos", systemImage: Router.musicVideos.label.icon)
                            .labelStyle(StatisticsLabel())
                    })
            }
        }
        .buttonStyle(.plain)    }
}

extension StatisticsView {

#if os(macOS)
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
            .font(.system(size: subItem ? 20 : 25))
            .padding(.vertical, subItem ? 10 : 20)
            .padding(.leading, subItem ? 20 : 0)
        }
    }
#endif

#if os(tvOS)
    /// Label style for statistics
    private struct StatisticsLabel: LabelStyle {
        var subItem: Bool = false
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon
                    .foregroundColor(subItem ? .secondary : Color("AccentColor"))
                    .frame(width: 40)
                configuration.title
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.system(size: subItem ? 30 : 35))
            .padding(.vertical, subItem ? 0 : 10)
            .padding(.leading, subItem ? 20 : 0)
        }
    }
#endif
}
