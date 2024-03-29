//
//  SidebarView.swift
//  Komodio (tvOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import AVFoundation

// MARK: Sidebar View

/// SwiftUI `View` for the sidebar (tvOS)
///
/// It is a bit of a hack to tame the Siri remote...
struct SidebarView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The focus state of the sidebar
    @FocusState private var isFocused: Bool
    /// Bool for the confirmation dialog
    @State private var isPresentingConfirmExit: Bool = false
    /// Router items to show in the sidebar
    let routerItems: [Router] = [
        .start,
        .favourites,
        .movies,
        .unwatchedMovies,
        .moviePlaylists,
        .tvshows,
        .unwachedEpisodes,
        .musicVideos,
        .search
    ]
    /// The sidebar selection
    @State private var sidebarSelection: Int = 0

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack(alignment: .leading) {
            Label(
                title: {
                    VStack(alignment: .leading) {
                        Text("Komodio")
                        Text(kodi.host.name)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }, icon: {
                    Image(systemName: "sparkles.tv")
                        .foregroundColor(sidebarSelection == 0 ? .orange : Color("AccentColor"))
                        .font(sidebarSelection == 0 ? .headline : .subheadline)
                        .frame(width: 40, height: 40, alignment: .center)
                })
            .padding(.vertical, 20)
            sidebarItem(router: routerItems[1])
            Section("Movies") {
                sidebarItem(router: routerItems[2])
                sidebarItem(router: routerItems[3])
                sidebarItem(router: routerItems[4])
            }
            Section("TV shows") {
                sidebarItem(router: routerItems[5])
                sidebarItem(router: routerItems[6])
            }
            Section("Music Videos") {
                sidebarItem(router: routerItems[7])
            }
            Section("Search") {
                sidebarItem(router: routerItems[8])
            }
        }
        .padding(.top)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .animation(.default, value: sidebarSelection)
        .focusable()
        .swipeGestures(
            onUp: {
                if isFocused {
                    sidebarSelection = sidebarSelection == 0 ? 0 : sidebarSelection - 1
                }
            },
            onDown: {
                if isFocused {
                    sidebarSelection = routerItems.count - 1 == sidebarSelection ?
                    sidebarSelection : sidebarSelection + 1
                }
            }
        )
        .focused($isFocused)
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                sidebarSelection = 0
            }
        }
        .task(id: sidebarSelection) {
            /// Set the sidebar selection as a ``Router`` item
            scene.mainSelection = routerItems[sidebarSelection]
            /// Reset the details
            scene.detailSelection = routerItems[sidebarSelection]
            /// Reset the navigationStack
            scene.navigationStack = []
            /// Play the navigation sound
            SiriRemoteController.playNavigationSound()
        }
        .onChange(of: scene.toggleSidebar) {
            isFocused = true
        }
        .onChange(of: isFocused) {
            scene.sidebarFocus = isFocused
        }
        .onExitCommand {
            isPresentingConfirmExit = true
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $isPresentingConfirmExit
        ) {
            Button("Exit Komodio") {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            }
        } message: {
            Text("Are you sure you want to exit?")
        }
    }

    /// SwiftUI `View` for an item in the sidebar
    @ViewBuilder func sidebarItem(router: Router) -> some View {
        Label(
            title: {
                VStack(alignment: .leading) {
                    Text(router.item.title)
                    Text(router.item.description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }, icon: {
                Image(systemName: router.item.icon)
                    .foregroundColor(routerItems[sidebarSelection] == router ? router.item.color : Color("AccentColor"))
                    .font(routerItems[sidebarSelection] == router ? .headline : .subheadline)
                    .frame(width: 40, height: 40, alignment: .center)
            })
        .padding(.bottom, 10)
    }
}
