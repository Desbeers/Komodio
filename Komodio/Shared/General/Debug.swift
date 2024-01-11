//
//  Debug.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension Color {

    /// Generate a random Color
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
