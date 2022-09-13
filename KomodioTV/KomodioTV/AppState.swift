//
//  AppState.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 18/05/2022.
//

import Foundation
import SwiftlyKodiAPI

class AppState: ObservableObject {
    
    /// The shared instance of this AppState class
    static let shared = AppState()
    /// The currently selected `MediaItem`
    @Published var reloadHomeItems: Bool = false
}
