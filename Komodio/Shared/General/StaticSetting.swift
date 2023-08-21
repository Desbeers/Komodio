//
//  StaticSetting.swift
//  Komodio
//
//  Created by Nick Berendsen on 15/08/2023.
//

import SwiftUI

/// Static settings for Komodio
enum StaticSetting {

#if os(macOS)

    /// The plaform
    static let platform: Parts.Platform = .macOS

    /// The width of the sidebar
    static let sidebarWidth: Double = 200

    /// The width of the sidebar when collapsed (tvOS only)
    static var sidebarCollapsedWidth: Double = 0

    /// The `NavigationSplitView` content column width
    static let contentWidth: Double = 400

    /// The default padding for details
    static let detailPadding: Double = 40

    /// The default padding for a cell
    static let cellPadding: Double = 10

    /// The default size of poster art
    static let posterSize = CGSize(width: 80, height: 120)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 90))]

    /// The default corner radius
    static let cornerRadius: Double = 6

#endif

#if os(tvOS)

    /// The plaform
    static let platform: Parts.Platform = .tvOS

    /// The width of the sidebar
    static let sidebarWidth: Double = 450

    /// The width of the sidebar when collapsed (tvOS only)
    static var sidebarCollapsedWidth: Double {
        self.sidebarWidth / 3
    }

    /// The `List` content column width
    /// - Note: Used when a list and details are in the same `View`
    static let contentWidth: Double = 400

    /// The default padding for details
    static let detailPadding: Double = 40

    /// The default padding for a cell
    static let cellPadding: Double = 40

    /// The default size of poster art
    static let posterSize = CGSize(width: 240, height: 360)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 426, height: 240)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 300))]

    /// The default corner radius
    static let cornerRadius: Double = 10

#endif

#if os(iOS)

    /// The plaform
    static let platform: Parts.Platform = .iPadOS

    /// The width of the sidebar
    static let sidebarWidth: Double = 250

    /// The width of the sidebar when collapsed (tvOS only)
    static var sidebarCollapsedWidth: Double = 0

    /// The `List` content column width
    /// - Note: Used when a list and details are in the same `View`
    static let contentWidth: Double = 220

    /// The default padding for details
    static let detailPadding: Double = 40

    /// The default padding for a cell
    static let cellPadding: Double = 20

    /// The default size of poster art
    static let posterSize = CGSize(width: 180, height: 270)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 200))]

    /// The default corner radius
    static let cornerRadius: Double = 8

#endif

#if os(visionOS)

    /// The plaform
    static let platform: Parts.Platform = .iPadOS

    /// The width of the sidebar
    static let sidebarWidth: Double = 250

    /// The width of the sidebar when collapsed (tvOS only)
    static var sidebarCollapsedWidth: Double = 0

    /// The `List` content column width
    /// - Note: Used when a list and details are in the same `View`
    static let contentWidth: Double = 220

    /// The default padding for details
    static let detailPadding: Double = 40

    /// The default padding for a cell
    static let cellPadding: Double = 20

    /// The default size of poster art
    static let posterSize = CGSize(width: 180, height: 270)

    /// The default size of thumb art
    static let thumbSize = CGSize(width: 213, height: 120)

    /// The default size of fanart
    static let fanartSize = CGSize(width: 960, height: 540)

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 200))]

    /// The default corner radius
    static let cornerRadius: Double = 8

#endif
}
