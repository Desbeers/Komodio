//
//  PartsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct PartsView {
///
}

extension PartsView {
    
    struct TitleHeader: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The Navigator model
        @EnvironmentObject var navigator: Navigator
        /// The View
        var body: some View {
            HStack {
                Text(appState.filter.title ?? "Komodio")
                    .font(.title)
                    //.padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                toolbarContents(navigator: navigator)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial).blendMode(.multiply)
        }
        
    }
}
