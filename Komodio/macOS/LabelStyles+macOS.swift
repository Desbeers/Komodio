//
//  LabelStyles+macOS.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

extension LabelStyles {
    
    /// Label style for a Grid item
    struct MenuItem: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration.icon
                    .font(.title)
                    //.foregroundColor(.accentColor)
                configuration.title
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
    }
}
