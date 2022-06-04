//
//  Modifierers.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 19/05/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ViewModifierSelection: ViewModifier {
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The selected media item
    let selectedItem: MediaItem?
    /// The view
    func body(content: Content) -> some View {
            content
            .animation(.default, value: selectedItem)
            .onChange(of: selectedItem) { item in
                if item != nil {
                    appState.selection = item
                }
            }
    }
}
