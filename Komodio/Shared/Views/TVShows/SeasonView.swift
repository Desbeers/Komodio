//
//  SeasonView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Season View

/// SwiftUI `View` for one Season of a TV show (shared)
enum SeasonView {
    // Just a namespace
}

extension SeasonView {

    /// Define the cell parameters for a collection
    /// - Parameters:
    ///   - movie: The season
    ///   - style: The style of the collection
    /// - Returns: A ``KodiCell``
    static func cell(season: Video.Details.Season, style: ScrollCollectionStyle) -> KodiCell {
        let details: Router = .season(season: season)
        let stack: Router? = nil
        let count = season.episodes.count
#if os(macOS)
        let poster: CGSize = StaticSetting.posterSize
#else
        let poster = CGSize(width: StaticSetting.posterSize.width / 3, height: StaticSetting.posterSize.height / 3)
#endif
        return KodiCell(
            poster: poster,
            title: season.title,
            subtitle: "\(season.episodes.count) \(count == 1 ? "episode" : "episodes")",
            stack: stack,
            details: details
        )
    }
}
