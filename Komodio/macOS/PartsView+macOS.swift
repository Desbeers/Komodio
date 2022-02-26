//
//  PartsView+macOS.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

extension PartsView {
    
    struct TitleHeader: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The Navigator model
        @EnvironmentObject var navigator: Navigator
        /// The View
        var body: some View {
            HStack(alignment: .center) {
                Button(action: { navigator.goBack() }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .foregroundColor(navigator.canGoBack ? .accentColor : .secondary)
                }
                .disabled(!navigator.canGoBack)
                .help("Go back")
                .font(.title)
                .buttonStyle(.plain)
                VStack(alignment: .leading) {
                Text(appState.filter.title ?? "Komodio")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let subtitle = appState.filter.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
                }
                //toolbarContents(navigator: navigator)
            }
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            //.background(Color.white.opacity(0.8))
            .background(.thinMaterial)
            .ignoresSafeArea()
        }
        
    }
}
