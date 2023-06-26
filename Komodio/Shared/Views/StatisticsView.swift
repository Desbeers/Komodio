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
            switch KomodioApp.platform {

            case .macOS:
                return 20
            case .tvOS:
                return 35
            case .iPadOS:
                return 24
            }
        }
        func makeBody(configuration: Configuration) -> some View {

            HStack {
                configuration.icon
                    .frame(width: font * 2)
                configuration.title
                    .padding(.leading, subItem ? font / 2 : 0)
            }
            .font(.system(size: subItem ? font * 0.75 : font))
            .padding(.top, subItem ? 0 : font / 2)
            .padding(.bottom, font / 3)
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
