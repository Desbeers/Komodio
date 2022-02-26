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
    @State private var selected: String?
    /// The View
    var body: some View {
        NavigationView {
            List(selection: $selected) {
                ForEach(appState.titles, id: \.title) { (title, icon) in
                    Label(title, systemImage: icon)
                }
            }
            ContentView()
//                .toolbar {
//                    toolbarContents()
//                }
        }
        .environmentObject(appState)
        .onChange(of: selected) { newSelected in
            let pathComponents = navigator.path.components(separatedBy: "/").dropFirst()
            if newSelected != pathComponents.first {
                navigator.navigate("/" + (newSelected ?? ""))
            }
        }
        .onChange(of: navigator.path) { newPath in
            let components = newPath.components(separatedBy: "/").dropFirst()
            if selected != components.first {
                selected = components.first
            }
        }
    }
}
