//
//  HomeView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct HomeView: View {
    
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The Navigator model
    @EnvironmentObject var navigator: Navigator
    
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// Library loading state
    @State var libraryLoaded: Bool = false
    var body: some View {
        VStack {
            if libraryLoaded {
                Text("Homepage!")
            } else {
                LoadingView()
            }
            Button(action: {
                ///
            }, label: {
                Text("Reload Library")
            })
        }
        .task {
            print("HomeViewTask!")
            //navigator.clear()
            appState.filter.title = "Home"
            appState.filter.subtitle = nil
            appState.filter.media = .none
            libraryLoaded = kodi.library.isEmpty ? false : true
        }
        .onChange(of: kodi.library) { newLibrary in
            print("Library changed")
            libraryLoaded = newLibrary.isEmpty ? false : true
        }
    }
}
