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
        VStack {
            if appState.filter.media == .none {
                HStack(spacing: 0) {
                    ForEach(appState.titles, id: \.title) { (title, icon) in
                        Button(action: {
                            selected = title
                        }, label: {
                            Label(title, systemImage: icon)
                                .background(title == selected ? .green : .blue)
                        })
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
            } else {
                PartsView.TitleHeader()
            }
            ContentView()
            Spacer()
        }
        /// Handle the Siri remote
        .onExitCommand {
            if navigator.canGoBack {
                print("Going back")
                navigator.goBack()
            }
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
