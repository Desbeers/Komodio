//
//  StatisticsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Statistics View

/// SwiftUI View for library statistics (shared)
struct StatisticsView: View {
    /// The SceneState model
    @EnvironmentObject private var scene: SceneState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack(alignment: .leading) {
            if !kodi.library.movies.isEmpty {
                Label("\(kodi.library.movies.count) Movies", systemImage: Router.movies.label.icon)
                    .labelStyle(StatisticsLabel())
                let unwatched = kodi.library.movies
                    .filter { $0.playcount == 0 }
                if !unwatched.isEmpty {
                    Label("\(unwatched.count) Unwatched Movies", systemImage: "eye")
                        .labelStyle(StatisticsLabel(subItem: true))
                }
            }
            if !kodi.library.tvshows.isEmpty {
                Label("\(kodi.library.tvshows.count) TV shows", systemImage: Router.tvshows.label.icon)
                    .labelStyle(StatisticsLabel())
                let unwatched = kodi.library.episodes
                    .filter { $0.playcount == 0 }
                if !unwatched.isEmpty {
                    Label("\(unwatched.count) Unwatched Episodes", systemImage: "eye")
                        .labelStyle(StatisticsLabel(subItem: true))
                }
            }
            if !kodi.library.musicVideos.isEmpty {
                Label("\(kodi.library.musicVideos.count) Music Videos", systemImage: Router.musicVideos.label.icon)
                    .labelStyle(StatisticsLabel())
            }
        }
        .buttonStyle(.plain)    }
}

extension StatisticsView {

    // MARK: Statistics Label

    /// Label style for statistics
    private struct StatisticsLabel: LabelStyle {
        /// Bool if the label is a 'subitem'
        var subItem: Bool = false
        func makeBody(configuration: Configuration) -> some View {

#if os(macOS)
            HStack {
                configuration.icon
                    .foregroundColor(subItem ? .secondary : .primary)
                    .frame(width: 30)
                configuration.title
            }
            .font(.system(size: subItem ? 12 : 16))
            .padding(.top, subItem ? 0 : 10)
            .padding(.leading, subItem ? 20 : 0)
            .padding(.bottom)
#endif

#if os(tvOS)
            HStack(spacing: 0) {
                configuration.icon
                    .foregroundColor(subItem ? .secondary : .primary)
                    .padding(.trailing, 10)
                configuration.title
                    .foregroundColor(.primary)
            }
            .font(.system(size: subItem ? 20 : 35))
            .padding(.vertical, subItem ? 10 : 0)
            .padding(.leading, subItem ? 30 : 0)
#endif
        }
    }
}

extension StatisticsView {

    // MARK: Statistics Host Info

    /// SwiftUI View with host info
    struct HostInfo: View {
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                Text(kodi.host.name)
                    .font(.title)
                Text("Kodi \(kodi.properties.version.major).\(kodi.properties.version.minor)")
                    .font(.caption)
            }
        }
    }
}
