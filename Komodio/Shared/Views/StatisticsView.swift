//
//  StatisticsView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Statistics View

/// SwiftUI `View` for library statistics (shared)
struct StatisticsView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack(alignment: .leading) {
            if !kodi.library.movies.isEmpty {
                Label("\(kodi.library.movies.count) Movies", systemImage: Router.movies.item.icon)
                    .labelStyle(StatisticsLabel())
                let unwatched = kodi.library.movies
                    .filter { $0.playcount == 0 }
                if !unwatched.isEmpty {
                    Label("\(unwatched.count) Unwatched Movies", systemImage: "eye")
                        .labelStyle(StatisticsLabel(subItem: true))
                }
            }
            if !kodi.library.tvshows.isEmpty {
                Label("\(kodi.library.tvshows.count) TV shows", systemImage: Router.tvshows.item.icon)
                    .labelStyle(StatisticsLabel())
                let unwatched = kodi.library.episodes
                    .filter { $0.playcount == 0 }
                if !unwatched.isEmpty {
                    Label("\(unwatched.count) Unwatched Episodes", systemImage: "eye")
                        .labelStyle(StatisticsLabel(subItem: true))
                }
            }
            if !kodi.library.musicVideos.isEmpty {
                Label("\(kodi.library.musicVideos.count) Music Videos", systemImage: Router.musicVideos.item.icon)
                    .labelStyle(StatisticsLabel())
            }
        }
        .padding(.vertical)
    }
}

extension StatisticsView {

    // MARK: Statistics Label

    /// Label style for statistics
    private struct StatisticsLabel: LabelStyle {
        /// Bool if the label is a 'subitem'
        var subItem: Bool = false
        /// Calculate the font size
        var font: Double {
            switch StaticSetting.platform {

            case .macOS:
                return 20
            case .tvOS:
                return 25
            case .iPadOS:
                return 24
            case .visionOS:
                return 18
            }
        }
        func makeBody(configuration: Configuration) -> some View {

            HStack(spacing: 0) {
                configuration.icon
                    .frame(width: font * 2)
                configuration.title
                    .padding(.leading, subItem ? font / 2 : 0)
            }
            .font(.system(size: subItem ? font * 0.75 : font))
            .padding(.top, subItem ? 0 : font / 2)
            .padding(.bottom, font / 4)
        }
    }
}

extension StatisticsView {

    // MARK: Statistics Host Info

    /// SwiftUI `View` with host info
    struct HostInfo: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self) private var kodi

        // MARK: Body of the View

        /// The body of the `View`
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
