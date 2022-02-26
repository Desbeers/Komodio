//
//  TabViewRouting
//  Created by Freek (github.com/frzi) 2021
//

import SwiftUI
import SwiftUIRouter

struct RootView: View {    
    /// The AppState model
    @StateObject var appState: AppState = AppState()
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    /// The selection in the list
    @State var selected = -1
    /// The View
    var body: some View {
        TabView(selection: $selected) {
            ForEach(0..<appState.titles.count) { index in
                VStack {
                    HStack(spacing: 20) {
                        toolbarContents()
                    }
                    Spacer()
                    ContentView()
                    Spacer()
                }
                .tag(index)
                .tabItem {
                    Image(systemName: appState.titles[index].image)
                    Text(appState.titles[index].title)
                }
            }
        }
        .environmentObject(appState)
        .onChange(of: selected) { newIndex in
            navigator.navigate("/" + appState.titles[newIndex].title)
        }
        .onChange(of: navigator.path) { newPath in
            let components = newPath.components(separatedBy: "/").dropFirst()
            if let index = appState.titles.firstIndex(where: { $0.title == components.first }) {
                selected = index
            }
        }
    }
}
