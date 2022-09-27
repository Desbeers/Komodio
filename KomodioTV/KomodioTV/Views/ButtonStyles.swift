//
//  ButtonStyles.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of Button styles
struct ButtonStyles {
    /// Just a Namespace here...
}

extension ButtonStyles {
    struct DetailsButton: ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(0)
                .font(.headline)
                .cornerRadius(10)
        }

    }
}
