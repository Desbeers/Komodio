//
//  ButtonStyles.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of SwiftUI Button styles
enum ButtonStyles {
    /// Just a Namespace here...
}

extension ButtonStyles {
    
    /// The style for a ``DetailsView`` button
    struct DetailsButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(0)
                .font(.headline)
                .cornerRadius(10)
        }
    }
}
