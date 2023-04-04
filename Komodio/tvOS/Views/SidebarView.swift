//
//  SidebarView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import AVFoundation

// MARK: Sidebar View

/// SwiftUI View for the sidebar (tvOS)
///
/// It is a bit of a hack to tame the Siri remote...
struct SidebarView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The focus state of the sidebar
    @FocusState var isFocused: Bool
    /// Router items to show in the sidebar
    let sidebarItems: [Router] = [
        .start,
        .favourites,
        .movies,
        .unwatchedMovies,
        .playlists,
        .tvshows,
        .unwachedEpisodes,
        .musicVideos,
        .search
    ]
    /// The sidebar selection
    @State var sidebarSelection: Int = 0 {
        didSet {
            /// Set the sidebar selection as a ``Router`` item
            scene.sidebarSelection = sidebarItems[sidebarSelection]
            /// Reset the details
            scene.details = sidebarItems[sidebarSelection]
            /// Reset the navigationStackPath
            scene.navigationStackPath = NavigationPath()
            /// Reset the background
            scene.selectedKodiItem = nil
        }
    }
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
                        .foregroundColor(sidebarSelection == 0 ? .orange : Color("AccentColor"))
                        .font(sidebarSelection == 0 ? .headline : .subheadline)
                        .frame(width: 40, height: 40, alignment: .center)
                })
            .padding(.vertical, 20)
            sidebarItem(item: sidebarItems[1])
            Section("Movies") {
                sidebarItem(item: sidebarItems[2])
                sidebarItem(item: sidebarItems[3])
                sidebarItem(item: sidebarItems[4])
            }
            Section("TV shows") {
                sidebarItem(item: sidebarItems[5])
                sidebarItem(item: sidebarItems[6])
            }
            Section("Music Videos") {
                sidebarItem(item: sidebarItems[7])
            }
            Section("Search") {
                sidebarItem(item: sidebarItems[8])
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
                    /// Play the navigation sound
                    Parts.playNavigationSound()
                }
            },
            onDown: {
                if isFocused {
                    sidebarSelection = sidebarItems.count - 1 == sidebarSelection ?
                    sidebarSelection : sidebarSelection + 1
                    /// Play the navigation sound
                    Parts.playNavigationSound()
                }
            }
        )
        .focused($isFocused)
        .task(id: kodi.status) {
            if kodi.status != .loadedLibrary {
                sidebarSelection = 0
            }
        }
        .onChange(of: scene.toggleSidebar) { _ in
            isFocused = true
        }
    }

    /// SwiftUI View for an item in the sidebar
    @ViewBuilder func sidebarItem(item: Router) -> some View {
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
                    .foregroundColor(sidebarItems[sidebarSelection] == item ? item.color : Color("AccentColor"))
                    .font(sidebarItems[sidebarSelection] == item ? .headline : .subheadline)
                    .frame(width: 40, height: 40, alignment: .center)
            })
        .padding(.bottom, 10)
    }
}
