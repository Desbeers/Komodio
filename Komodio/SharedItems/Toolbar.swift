//
//  Toolbar.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

extension RootView {

@ViewBuilder func toolbarContents() -> some View {
    Button(action: { navigator.goBack() }) {
        Image(systemName: "arrow.left")
    }
    .disabled(!navigator.canGoBack)
    .help("Go back")

    Button(action: { navigator.goForward() }) {
        Image(systemName: "arrow.right")
    }
    .disabled(!navigator.canGoForward)
    .help("Go forward")
    
    Button(action: { navigator.clear() }) {
        Image(systemName: "clear")
    }
    .disabled(!navigator.canGoBack && !navigator.canGoForward)
    .help("Clear history stacks")

    Button(action: { navigator.navigate("..") }) {
        Image(systemName: "arrow.turn.left.up")
    }
    .disabled(navigator.path == "/users" || navigator.path == "/shortcuts")
    .help("Go to parent")
}
}
