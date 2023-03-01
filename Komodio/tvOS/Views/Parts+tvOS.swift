//
//  Parts+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import Foundation
import AVFoundation

extension Parts {

    /// Play the navigation sound when navigating the main menu
    static func playNavigationSound() {
        /// I can't find the proper ID of this sound so I use the URL instead...
        var systemSoundID: SystemSoundID = 1
        let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/focus_change_large.caf")
        AudioServicesCreateSystemSoundID(url as CFURL, &systemSoundID)
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
