//
//  ButtonStyles.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 01/05/2022.
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
