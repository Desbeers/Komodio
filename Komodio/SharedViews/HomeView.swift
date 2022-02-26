//
//  HomeView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct HomeView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// Library loading state
    @State var libraryLoaded: Bool = false
    var body: some View {
        Group {
            if libraryLoaded {
                Text("Homepage!")
            } else {
                LoadingView()
            }
        }
        .task {
            print("HomeViewTask!")
            libraryLoaded = kodi.library.isEmpty ? false : true
        }
        .onChange(of: kodi.library) { newLibrary in
            print("Library changed")
            libraryLoaded = newLibrary.isEmpty ? false : true
        }
    }
}
