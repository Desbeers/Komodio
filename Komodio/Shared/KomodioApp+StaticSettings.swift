//
//  KomodioApp+StaticSettings.swift
//  Komodio
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension KomodioApp {

    // MARK: Static settings for Komodio

#if os(macOS)

    /// The plaform
    static let platform: Parts.Platform = .macOS

    /// The `NavigationSplitView` detail width
    /// - Note: Used for the width as well the animation
    static let detailWidth: Double = 400

    /// The default size of poster art
    static let posterSize = CGSize(width: 80, height: 120)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

    /// The default corner radius
    static let cornerRadius: Double = 6
#endif

#if os(tvOS)

    /// The plaform
    static let platform: Parts.Platform = .tvOS

    /// The default size of poster art
    static let posterSize = CGSize(width: 240, height: 360)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// The width of the sidebar
    static let sidebarWidth: Double = 450

    /// The width of the sidebar when collapsed
    static var sidebarCollapsedWidth: Double {
        KomodioApp.sidebarWidth / 3
    }

    /// The default corner radius
    static let cornerRadius: Double = 10

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 260))]
#endif

#if os(iOS)

    /// The plaform
    static let platform: Parts.Platform = .iPadOS

    /// The default size of poster art
    static let posterSize = CGSize(width: 180, height: 270)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// The default corner radius
    static let cornerRadius: Double = 8

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 200))]
#endif
}
