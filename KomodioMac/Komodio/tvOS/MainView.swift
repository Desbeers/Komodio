//
//  MainView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 02/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {

    static let posterSize = CGSize(width: 240, height: 360)

    let sidebarWidth: Double = 450

    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector
    /// The SceneState model
    @StateObject var scene = SceneState()

    @FocusState var isFocused: Bool

    var body: some View {

        ZStack(alignment: .leading) {

            HStack {
                ContentView()
                    .focusSection()
                    //.padding(.vertical, 100)
                    .frame(width: ContentView.columnWidth)
                    .background(.yellow)
                    .zIndex(100)
                    .focusSection()
                    //.padding(.leading, isFocused ? sidebarWidth / 2 : 0)
                DetailView()
                    .focusSection()
                    .frame(maxWidth: .infinity)
                    .zIndex(20)
                    .focusSection()
            }
            .zIndex(50)
            .padding(.leading, isFocused ? sidebarWidth : sidebarWidth - 300)

            SidebarView()
                .frame(width: sidebarWidth)
                .opacity(isFocused ? 1 : 0.4)
                .background(.ultraThinMaterial)
                .offset(x: isFocused ? 0 : 300 - sidebarWidth, y: 0)
                .focused($isFocused)
                .focusSection()
        }
        .animation(.default, value: scene.details)
        .animation(.default, value: isFocused)
        .ignoresSafeArea()
        .environmentObject(scene)
    }
}
