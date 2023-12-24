//
//  KodiCell.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyKodiAPI

/// Structure with details for a collection cell
struct KodiCell {
    /// The size of the poster
    var poster: CGSize = StaticSetting.posterSize
    /// The size of the fanart
    var fanart: CGSize = CGSize(width: StaticSetting.posterSize.height * 1.78, height: StaticSetting.posterSize.height)
    /// The title of the item
    let title: String
    /// The subtitle of the item
    let subtitle: String
    /// The optional router item for the navigation stack
    var stack: Router?
    /// The optional router item for the detail view
    var details: Router?
}
