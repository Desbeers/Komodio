//
//  LabelStyles.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A collection of Label styles
struct LabelStyles {
    /// Just a Namespace here...
}

extension LabelStyles {

    /// Label style for a DetailsView Play Button
    struct PlayButton: LabelStyle {
        @Environment(\.isFocused) var focused: Bool
        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 0) {
                configuration.icon
                    .padding(.trailing)
                configuration.title
                    .lineLimit(1)
            }
            .padding(.horizontal, 40)
            .frame(height: 100)
            .foregroundColor(.black)
            .background(.white)
            .opacity(focused ? 1 : 0.8)
        }
    }
    
    /// Label style for a DetailsView Button
    struct DetailsButton: LabelStyle {
        @Environment(\.isFocused) var focused: Bool
        func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 0) {
                configuration.icon
                    .padding(.trailing)
                configuration.title
                    .lineLimit(1)
                    .frame(width: 300)
            }
            .padding(.horizontal, 40)
            .frame(height: 100)
            .foregroundColor(.black)
            .background(.white)
            .opacity(focused ? 1 : 0.8)
        }
    }
    
    /// Label style for details
    struct Details: LabelStyle {
        @Environment(\.isFocused) var focused: Bool
        func makeBody(configuration: Configuration) -> some View {
            HStack(alignment: .top, spacing: 0) {
                configuration.icon
                    .frame(width: 80)
                configuration.title
            }
            .padding(.bottom)
        }
    }

}
