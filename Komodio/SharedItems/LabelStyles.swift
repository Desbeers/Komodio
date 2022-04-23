//
//  LabelStyles.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of Label styles
struct LabelStyles {
    /// Just a Namespace here...
}

extension LabelStyles {
    
    /// Label style for a Grid item
    struct GridItem: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration.icon
                    .macOS { $0.font(.title).foregroundColor(.accentColor) }
                    .iOS { $0.font(.title).foregroundColor(.accentColor) }
                configuration.title
                    .padding(.top)
            }
        }
    }
    
    /// Label style for a Menu item
    struct MenuItem: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration.icon
                    .macOS { $0.font(.title3).foregroundColor(.accentColor) }
                    .iOS { $0.font(.title).foregroundColor(.accentColor) }
                    .frame(maxHeight: 50)
                configuration.title
                    //.padding(.top)
            }
        }
    }
}
