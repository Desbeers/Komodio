//
//  SidebarView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import AVFoundation

/// SwiftUI View for the sidebar (tvOS)
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The focus state of the sidebar
    @FocusState var isFocused: Bool

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        VStack(alignment: .leading) {
            Label(
                title: {
                    VStack(alignment: .leading) {
                        Text("Komodio")
                        Text(kodi.host.bonjour?.name ?? kodi.status.message)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }, icon: {
                    Image(systemName: "sparkles.tv")
                        .foregroundColor(scene.mainSelection == 0 ? Color("AccentColor") : .gray)
                        .font(scene.mainSelection == 0 ? .headline : .subheadline)
                        .frame(width: 40, height: 40)
                })
            .padding()
            Section("Movies") {
                sidebarItem(item: scene.sidebarItems[1], selection: scene.mainSelection)
                sidebarItem(item: scene.sidebarItems[2], selection: scene.mainSelection)
            }
            Section("TV shows") {
                sidebarItem(item: scene.sidebarItems[3], selection: scene.mainSelection)
                sidebarItem(item: scene.sidebarItems[4], selection: scene.mainSelection)
            }
            Section("Music Videos") {
                sidebarItem(item: scene.sidebarItems[5], selection: scene.mainSelection)
            }
            Section("Search") {
                sidebarItem(item: scene.sidebarItems[6], selection: scene.mainSelection)
            }
        }
        .padding(.top)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .focusable()
        .swipeGestures(
            onUp: {
                if isFocused {
                    scene.mainSelection = scene.mainSelection == 0 ? 0 : scene.mainSelection - 1
                    let systemSoundID: SystemSoundID = 1306
                    AudioServicesPlaySystemSound(systemSoundID)
                }
            },
            onDown: {
                if isFocused {
                    scene.mainSelection = scene.sidebarItems.count - 1 == scene.mainSelection ? scene.mainSelection : scene.mainSelection + 1
                    let systemSoundID: SystemSoundID = 1104
                    AudioServicesPlaySystemSound(systemSoundID)
                }
            }
        )
        .focused($isFocused)
    }

    /// SwiftUI View for an item in the sidebar
    @ViewBuilder func sidebarItem(item: Router, selection: Int = 0) -> some View {
        Label(
            title: {
                VStack(alignment: .leading) {
                    Text(item.label.title)
                    Text(item.label.description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }, icon: {
                Image(systemName: item.label.icon)
                    .foregroundColor(scene.sidebarItems[selection] == item ? Color("AccentColor") : .gray)
                    .font(scene.sidebarItems[selection] == item ? .headline : .subheadline)
                    .frame(width: 40, height: 40)
            })
        .padding()
    }
}
