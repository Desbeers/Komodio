//
//  RootView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

/// The Root View of Komodio
struct RootView: View {
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The selection in the list
    @State private var selection: String?
    /// The View
    var body: some View {
        StackNavView {
            List(selection: $selection) {
                Section(header: Text("Library")) {
                    NavBarView.Items(selection: $selection)
                }
            }
            ContentView()
                .background(Color(nsColor: .textBackgroundColor))
//                .toolbar {
//                    toolbarContents()
//                }
        }
        .environmentObject(appState)
        .onChange(of: selection) { newSelection in
            let pathComponents = navigator.path.components(separatedBy: "/").dropFirst()
            if newSelection != pathComponents.first {
                navigator.navigate("/" + (newSelection ?? ""))
            }
        }
        .onChange(of: navigator.path) { newPath in
            let components = newPath.components(separatedBy: "/").dropFirst()
            if selection != components.first {
                selection = components.first
            }
        }
    }
}
